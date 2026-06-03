import SwiftUI
import Combine

@MainActor
final class WritingQuizViewModel: ObservableObject {
    let level: WritingLevel

    @Published var currentIndex: Int = 0
    @Published var currentCharacter: String = ""
    @Published var showSuccessBanner: Bool = false
    @Published var mistakeCount: Int = 0
    @Published var correctStrokesInChar: Int = 0
    
    var onFinish: (() -> Void)?

    init(level: WritingLevel) {
        self.level = level
    }

    func onAppear() {
        if currentCharacter.isEmpty {
            currentCharacter = level.characters.first ?? ""
        }
    }

    func handleCorrectStroke(_ strokeNum: Int) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        correctStrokesInChar = strokeNum + 1
    }

    func handleMistake() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        mistakeCount += 1
    }

    func handleQuizCompleted() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)

        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            showSuccessBanner = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            withAnimation {
                self.showSuccessBanner = false
            }

            let nextIndex = self.currentIndex + 1
            if nextIndex < self.level.characters.count {
                self.currentIndex = nextIndex
                self.currentCharacter = self.level.characters[nextIndex]
                self.correctStrokesInChar = 0
            } else {
                self.onFinish?()
            }
        }
    }

    deinit {}
}

