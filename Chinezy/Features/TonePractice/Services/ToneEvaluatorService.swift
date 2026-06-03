import SwiftUI
import Foundation
import AVFoundation
import SoundAnalysis
import CoreML
import Combine

// MARK: - Service State

enum ToneEvaluatorState: Equatable {
    case idle
    case recording
    case analyzing
    case result
}

// MARK: - Service

final class ToneEvaluatorService: NSObject, ObservableObject {

    // MARK: - Published State

    @Published var state: ToneEvaluatorState = .idle
    @Published var predictedTone: String = ""
    @Published var targetToneIdentifier: String?
    @Published var errorMessage: String?

    // MARK: - Prediction Buffer

    nonisolated(unsafe) private var accumulatedPredictions: [String] = []
    nonisolated(unsafe) private var instantPassTriggered: Bool = false
    nonisolated(unsafe) private let bufferLock = NSLock()

    // MARK: - Audio Properties

    nonisolated(unsafe) private let audioEngine = AVAudioEngine()
    nonisolated(unsafe) private var streamAnalyzer: SNAudioStreamAnalyzer?
    nonisolated(unsafe) private var classifyRequest: SNClassifySoundRequest?
    nonisolated(unsafe) private let analysisQueue = DispatchQueue(
        label: "com.chinezy.toneAnalysis"
    )

    // MARK: - Lifecycle

    override init() {
        super.init()
    }

    deinit {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }

    // MARK: - Microphone Permission

    func requestMicrophonePermission() {
        AVAudioApplication.requestRecordPermission { [weak self] granted in
            guard let self else { return }
            if !granted {
                Task { @MainActor in
                    self.errorMessage = "Microphone access is required."
                }
            }
        }
    }

    // MARK: - Recording Controls

    func startRecording() {
        // Reset
        predictedTone = ""
        errorMessage = nil
        bufferLock.lock()
        accumulatedPredictions.removeAll()
        instantPassTriggered = false
        bufferLock.unlock()

        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.record, mode: .measurement, options: .duckOthers)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            errorMessage = "Audio session error: \(error.localizedDescription)"
            return
        }

        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)

        guard format.sampleRate > 0 else {
            errorMessage = "Invalid audio format."
            return
        }

        // SoundAnalysis handles resampling from any sample rate → 16kHz automatically.
        let analyzer = SNAudioStreamAnalyzer(format: format)
        streamAnalyzer = analyzer

        do {
            let config = MLModelConfiguration()
            let model = try HanziSoundClassifierVER5(configuration: config)
            let request = try SNClassifySoundRequest(mlModel: model.model)
            classifyRequest = request
            try analyzer.add(request, withObserver: self)
        } catch {
            errorMessage = "Model load error: \(error.localizedDescription)"
            return
        }

        // Feed every buffer straight to SoundAnalysis — no volume gate.
        // The model itself distinguishes speech from silence via its training.
        inputNode.installTap(onBus: 0, bufferSize: 8192, format: format) { [weak self] buffer, time in
            guard let self else { return }
            self.analysisQueue.async {
                self.streamAnalyzer?.analyze(buffer, atAudioFramePosition: time.sampleTime)
            }
        }

        do {
            audioEngine.prepare()
            try audioEngine.start()
            state = .recording
            print("🎙️ [ToneEvaluator] Recording started — format: \(format.sampleRate)Hz, target: \(targetToneIdentifier ?? "none")")
        } catch {
            errorMessage = "Engine start error: \(error.localizedDescription)"
        }
    }

    private func stopAudioEngine() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        if let req = classifyRequest { streamAnalyzer?.remove(req) }
        streamAnalyzer = nil

        try? AVAudioSession.sharedInstance().setActive(
            false, options: .notifyOthersOnDeactivation
        )
    }

    func stopAndEvaluate() {
        stopAudioEngine()

        // If instant pass already triggered, the result is already set.
        bufferLock.lock()
        let alreadyPassed = instantPassTriggered
        let predictions = accumulatedPredictions
        bufferLock.unlock()

        if alreadyPassed { return }

        state = .analyzing

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self else { return }

            // Double-check in case instant pass fired after stopAudioEngine.
            self.bufferLock.lock()
            let passedInFlight = self.instantPassTriggered
            self.bufferLock.unlock()
            if passedInFlight { return }

            // Use accumulated predictions as fallback.
            if predictions.isEmpty {
                self.predictedTone = "Unclear"
            } else {
                self.predictedTone = Self.mode(of: predictions)
            }

            print("📊 [ToneEvaluator] Fallback result: \(self.predictedTone) from \(predictions.count) predictions: \(predictions)")
            self.state = .result
        }
    }

    func reset() {
        predictedTone = ""
        errorMessage = nil
        targetToneIdentifier = nil
        bufferLock.lock()
        instantPassTriggered = false
        bufferLock.unlock()
        state = .idle
    }

    // MARK: - Helpers

    private static func mode(of array: [String]) -> String {
        var counts: [String: Int] = [:]
        for item in array { counts[item, default: 0] += 1 }
        return counts.max(by: { $0.value < $1.value })?.key ?? ""
    }
}

// MARK: - SNResultsObserving

extension ToneEvaluatorService: @preconcurrency SNResultsObserving {
    nonisolated func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let classification = result as? SNClassificationResult,
              let top = classification.classifications.first else {
            return
        }

        print("🔍 [SoundAnalysis] \(top.identifier): \(String(format: "%.0f%%", top.confidence * 100))")

        // Instant Pass: correct tone detected at ≥ 80% confidence → immediate success.
        if top.confidence >= 0.80 {
            Task { @MainActor in
                if self.state == .recording,
                   let target = self.targetToneIdentifier,
                   top.identifier == target {
                    self.bufferLock.lock()
                    self.instantPassTriggered = true
                    self.bufferLock.unlock()

                    self.predictedTone = target
                    self.stopAudioEngine()
                    self.state = .result
                    print("✅ [ToneEvaluator] Instant pass! Detected \(target)")
                }
            }
        }

        // Accumulate any prediction ≥ 50% as fallback data.
        if top.confidence >= 0.50 {
            bufferLock.lock()
            accumulatedPredictions.append(top.identifier)
            bufferLock.unlock()
        }
    }

    nonisolated func request(_ request: SNRequest, didFailWithError error: Error) {
        let msg = error.localizedDescription
        print("❌ [SoundAnalysis] Error: \(msg)")
        Task { @MainActor in self.errorMessage = "Classification error: \(msg)" }
    }

    nonisolated func requestDidComplete(_ request: SNRequest) { }
}
