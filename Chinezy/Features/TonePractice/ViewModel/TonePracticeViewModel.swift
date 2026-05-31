import SwiftUI
import Combine

@MainActor
final class TonePracticeViewModel: ObservableObject {
    
    // Dependencies
    private let toneService: ToneEvaluatorService
    
    // State
    @Published var selectedIndex: Int = 0 {
        didSet {
            // Reset evaluator when the user swipes to a new target
            resetService()
        }
    }
    
    // Data
    let targets = HanziTarget.defaults
    
    var currentTarget: HanziTarget {
        targets[selectedIndex]
    }
    
    // Forwarded states from service
    var serviceState: ToneEvaluatorState {
        toneService.state
    }
    
    var errorMessage: String? {
        get { toneService.errorMessage }
        set { toneService.errorMessage = newValue }
    }
    
    // Combine subscription
    private var cancellables = Set<AnyCancellable>()
    
    init(toneService: ToneEvaluatorService = ToneEvaluatorService()) {
        self.toneService = toneService
        
        // Forward changes from toneService to self so View updates
        toneService.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    func requestMicrophonePermission() {
        toneService.requestMicrophonePermission()
    }
    
    func startRecording() {
        toneService.targetToneIdentifier = currentTarget.targetTone
        toneService.startRecording()
    }
    
    func stopAndEvaluate() {
        toneService.stopAndEvaluate()
    }
    
    func resetService() {
        toneService.reset()
    }
    
    // MARK: - Verdict Logic
    
    struct Verdict {
        let text: String
        let icon: String
        let color: Color
    }

    func evaluateResult() -> Verdict {
        let predicted = toneService.predictedTone

        if predicted == "Unclear" {
            return Verdict(
                text: "Unclear",
                icon: "exclamationmark.triangle.fill",
                color: .orange
            )
        } else if predicted == currentTarget.targetTone {
            return Verdict(
                text: "Correct! \(displayTone(predicted))",
                icon: "checkmark.circle.fill",
                color: .green
            )
        } else {
            let expectedNum = currentTarget.toneNumber.map { String($0) } ?? "?"
            return Verdict(
                text: "Detected \(displayTone(predicted)) — expected Tone \(expectedNum)",
                icon: "xmark.circle.fill",
                color: .red
            )
        }
    }

    private func displayTone(_ raw: String) -> String {
        switch raw {
        case "Tone_1": return "Tone 1 (flat)"
        case "Tone_2": return "Tone 2 (rising)"
        case "Tone_3": return "Tone 3 (dipping)"
        case "Tone_4": return "Tone 4 (falling)"
        default:       return raw
        }
    }
}

