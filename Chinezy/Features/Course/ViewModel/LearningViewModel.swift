import Foundation
import Combine
import AVFoundation

public class LearningViewModel: ObservableObject {
    @Published public var currentSubChapter: SubChapter?
    @Published public var currentFlashcardIndex: Int = 0
    @Published public var isCardFlipped: Bool = false
    @Published public var isShowingDialog: Bool = false

    private var audioPlayer: AVPlayer?
    private let speechSynthesizer = AVSpeechSynthesizer()

    public init() {}

    public func startLearning(subChapter: SubChapter) {
        currentSubChapter = subChapter
        currentFlashcardIndex = 0
        isCardFlipped = false
        isShowingDialog = false
        stopAudio()
    }

    public var currentFlashcard: Flashcard? {
        guard let subChapter = currentSubChapter,
              currentFlashcardIndex < subChapter.flashcards.count else { return nil }
        return subChapter.flashcards[currentFlashcardIndex]
    }

    public var isOnLastFlashcard: Bool {
        guard let subChapter = currentSubChapter else { return false }
        return currentFlashcardIndex >= subChapter.flashcards.count - 1
    }

    public func flipCard() {
        isCardFlipped.toggle()
    }

    public func goToNextFlashcard() {
        guard let subChapter = currentSubChapter,
              currentFlashcardIndex < subChapter.flashcards.count - 1 else { return }
        stopAudio()
        currentFlashcardIndex += 1
        isCardFlipped = false
    }

    public func goToPreviousFlashcard() {
        stopAudio()
        if isShowingDialog {
            isShowingDialog = false
            return
        }
        guard currentFlashcardIndex > 0 else { return }
        currentFlashcardIndex -= 1
        isCardFlipped = false
    }

    public func openDialog() {
        stopAudio()
        isShowingDialog = true
    }

    public func playFlashcardAudio() {
        guard let audioString = currentFlashcard?.audioRef,
            !audioString.isEmpty,
            let encodedString = audioString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: encodedString) else { return }
        audioPlayer = AVPlayer(url: url)
        audioPlayer?.play()
    }

    public func playDialogAudio() {
        guard let text = currentSubChapter?.dialogText, !text.isEmpty else { return }
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
        utterance.rate = 0.4
        speechSynthesizer.speak(utterance)
    }

    public func stopAudio() {
        audioPlayer?.pause()
        audioPlayer = nil
        speechSynthesizer.stopSpeaking(at: .immediate)
    }
}
