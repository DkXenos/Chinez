import SwiftUI
import Foundation
import Combine
import AVFoundation

class LearningViewModel: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    @Published public var currentSubChapter: SubChapter?
    @Published public var currentFlashcardIndex: Int = 0
    @Published public var isCardFlipped: Bool = false
    @Published public var isShowingDialog: Bool = false
    @Published public var isPlayingDialog: Bool = false
    
    private var currentDialogIndex: Int = 0

    private var audioPlayer: AVPlayer?
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    override init() {
        super.init()
        speechSynthesizer.delegate = self
        configureAudioSession()
    }
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }

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
        guard let flashcard = currentFlashcard else { return }
        
        speechSynthesizer.stopSpeaking(at: .immediate)
        
        if let audioString = flashcard.audioRef,
           !audioString.isEmpty,
           let url = Bundle.main.url(forResource: audioString, withExtension: "mp3") {
            audioPlayer = AVPlayer(url: url)
            audioPlayer?.play()
            return
        }
        
        let utterance = AVSpeechUtterance(string: flashcard.hanzi)
        utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
        utterance.rate = 0.4
        speechSynthesizer.speak(utterance)
    }

    public func toggleDialogAudio() {
        if isPlayingDialog {
            stopAudio()
            return
        }
        
        guard let lines = currentSubChapter?.dialogLines, !lines.isEmpty else { return }
        
        stopAudio()
        isPlayingDialog = true
        currentDialogIndex = 0
        
        playCurrentDialogLine()
    }
    
    private func playCurrentDialogLine() {
        guard let lines = currentSubChapter?.dialogLines, currentDialogIndex < lines.count else {
            isPlayingDialog = false
            return
        }
        
        let line = lines[currentDialogIndex]
        let zhVoices = AVSpeechSynthesisVoice.speechVoices().filter { $0.language == "zh-CN" }
        let voiceA = zhVoices.first
        let voiceB = zhVoices.count > 1 ? zhVoices[1] : zhVoices.first
        
        let utterance = AVSpeechUtterance(string: line.text)
        utterance.voice = line.speaker == "A" ? voiceA : voiceB
        utterance.rate = 0.4
        
        speechSynthesizer.speak(utterance)
    }

    public func stopAudio() {
        audioPlayer?.pause()
        audioPlayer = nil
        speechSynthesizer.stopSpeaking(at: .immediate)
        isPlayingDialog = false
        currentDialogIndex = 0
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        currentDialogIndex += 1
        
        guard let lines = currentSubChapter?.dialogLines, currentDialogIndex < lines.count else {
            isPlayingDialog = false
            return
        }
        
        DispatchQueue.main.addDelay(0.7) { [weak self] in
            guard let self = self, self.isPlayingDialog else { return }
            self.playCurrentDialogLine()
        }
    }
}

extension DispatchQueue {
    func addDelay(_ seconds: Double, completion: @escaping () -> Void) {
        self.asyncAfter(deadline: .now() + seconds, execute: completion)
    }
}
