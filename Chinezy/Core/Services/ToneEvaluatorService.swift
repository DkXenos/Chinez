import Foundation
import AVFoundation
import SoundAnalysis
import Combine

// MARK: – Service State

enum ToneEvaluatorState: Equatable {
    case idle
    case recording
    case analyzing
    case result
}

// MARK: – Service

final class ToneEvaluatorService: NSObject, ObservableObject {

    // MARK: – Published State

    @Published var state: ToneEvaluatorState = .idle
    @Published var predictedTone: String = ""
    @Published var errorMessage: String?

    // MARK: – Confidence Threshold

    /// Only predictions at or above this confidence are kept.
    private let confidenceThreshold: Double = 0.85

    // MARK: – Prediction Buffer

    /// Accumulated high‑confidence predictions collected while recording.
    /// Accessed from the analysis queue; guarded by `bufferLock`.
    nonisolated(unsafe) private var accumulatedPredictions: [String] = []
    nonisolated(unsafe) private let bufferLock = NSLock()

    // MARK: – Audio Properties

    nonisolated(unsafe) private let audioEngine = AVAudioEngine()
    nonisolated(unsafe) private var streamAnalyzer: SNAudioStreamAnalyzer?
    nonisolated(unsafe) private var classifyRequest: SNClassifySoundRequest?
    nonisolated(unsafe) private let analysisQueue = DispatchQueue(
        label: "com.chinezy.toneAnalysis"
    )

    // MARK: – Lifecycle

    override init() {
        super.init()
    }

    deinit {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }

    // MARK: – Microphone Permission

    func requestMicrophonePermission() {
        AVAudioApplication.requestRecordPermission { [weak self] granted in
            guard let self else { return }
            if !granted {
                Task { @MainActor in
                    self.errorMessage = "Microphone access is required to evaluate your pronunciation."
                }
            }
        }
    }

    // MARK: – Recording Controls

    /// Clears the buffer and begins capturing + classifying audio.
    func startRecording() {
        // Reset
        predictedTone = ""
        errorMessage = nil
        bufferLock.lock()
        accumulatedPredictions.removeAll()
        bufferLock.unlock()

        // Audio session
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.record, mode: .measurement, options: .duckOthers)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            errorMessage = "Audio session error: \(error.localizedDescription)"
            return
        }

        // Format
        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)

        guard format.sampleRate > 0 else {
            errorMessage = "Invalid audio format — no microphone available."
            return
        }

        // Analyzer + model
        let analyzer = SNAudioStreamAnalyzer(format: format)
        streamAnalyzer = analyzer

        do {
            let config = MLModelConfiguration()
            let model = try HanziSoundClassifierVER1(configuration: config)
            let request = try SNClassifySoundRequest(mlModel: model.model)
            classifyRequest = request
            try analyzer.add(request, withObserver: self)
        } catch {
            errorMessage = "Model load error: \(error.localizedDescription)"
            return
        }

        // Tap
        inputNode.installTap(onBus: 0, bufferSize: 8192, format: format) {
            [weak self] buffer, time in
            guard let self else { return }
            self.analysisQueue.async {
                self.streamAnalyzer?.analyze(buffer, atAudioFramePosition: time.sampleTime)
            }
        }

        // Start
        do {
            audioEngine.prepare()
            try audioEngine.start()
            state = .recording
        } catch {
            errorMessage = "Engine start error: \(error.localizedDescription)"
        }
    }

    /// Stops the engine, aggregates the buffer, and publishes the verdict.
    func stopAndEvaluate() {
        // Tear down audio pipeline
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        if let req = classifyRequest { streamAnalyzer?.remove(req) }
        streamAnalyzer = nil
        try? AVAudioSession.sharedInstance().setActive(
            false, options: .notifyOthersOnDeactivation
        )

        state = .analyzing

        // Snapshot the buffer
        bufferLock.lock()
        let predictions = accumulatedPredictions
        bufferLock.unlock()

        // Short delay so the user sees the analyzing spinner
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            guard let self else { return }

            if predictions.isEmpty {
                self.predictedTone = "Unclear / Too Noisy"
            } else {
                self.predictedTone = Self.mode(of: predictions)
            }
            self.state = .result
        }
    }

    /// Resets back to idle so the user can try again.
    func reset() {
        predictedTone = ""
        errorMessage = nil
        state = .idle
    }

    // MARK: – Helpers

    /// Returns the most frequent element in a non‑empty array.
    private static func mode(of array: [String]) -> String {
        var counts: [String: Int] = [:]
        for item in array { counts[item, default: 0] += 1 }
        return counts.max(by: { $0.value < $1.value })?.key ?? ""
    }
}

// MARK: – SNResultsObserving

extension ToneEvaluatorService: @preconcurrency SNResultsObserving {

    nonisolated func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let classification = result as? SNClassificationResult,
              let top = classification.classifications.first,
              top.confidence >= confidenceThreshold else {
            return          // Below threshold → discard (noise)
        }

        bufferLock.lock()
        accumulatedPredictions.append(top.identifier)
        bufferLock.unlock()
    }

    nonisolated func request(_ request: SNRequest, didFailWithError error: Error) {
        let msg = error.localizedDescription
        Task { @MainActor in self.errorMessage = "Classification error: \(msg)" }
    }

    nonisolated func requestDidComplete(_ request: SNRequest) { }
}
