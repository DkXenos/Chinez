import SwiftUI
//
//  QuizViewModel.swift
//  Chinez
//
//  VIEWMODEL untuk satu sesi kuis (QuizSessionView).
//  Mengelola: soal aktif, pilihan user, status periksa (feedback), skor, dan selesai.
//  Alur tiap soal: pilih opsi → submit() (periksa: skor + feedback) → advance() (lanjut).
//

import Foundation
import Combine

@MainActor
final class QuizViewModel: ObservableObject {

    let chapter: Chapter
    private let questions: [QuizQuestion]

    @Published private(set) var currentIndex: Int = 0
    @Published var selectedOption: Int?
    @Published private(set) var isRevealed: Bool = false
    @Published private(set) var correctCount: Int = 0
    @Published private(set) var isFinished: Bool = false

    init(chapter: Chapter) {
        self.chapter = chapter
        self.questions = chapter.questions
    }

    // MARK: - Derived state (dibaca oleh View)

    var currentQuestion: QuizQuestion { questions[currentIndex] }
    var totalQuestions: Int { questions.count }
    var questionNumber: Int { currentIndex + 1 }
    var isLastQuestion: Bool { currentIndex == totalQuestions - 1 }
    var hasSelection: Bool { selectedOption != nil }

    /// Indeks opsi yang benar untuk soal saat ini.
    var correctIndex: Int { currentQuestion.answerIndex }
    /// Teks jawaban yang benar (untuk ditampilkan saat user salah).
    var correctAnswerText: String { currentQuestion.options[correctIndex] }
    /// True bila pilihan user pada soal saat ini benar.
    var isCurrentCorrect: Bool { selectedOption == correctIndex }

    /// Progres 0.0–1.0 untuk progress bar.
    var progress: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(currentIndex + 1) / Double(totalQuestions)
    }

    var wrongCount: Int { totalQuestions - correctCount }

    var scorePercentage: Int {
        guard totalQuestions > 0 else { return 0 }
        return Int((Double(correctCount) / Double(totalQuestions) * 100).rounded())
    }

    // MARK: - Actions (dipanggil oleh View)

    func select(_ index: Int) {
        guard !isRevealed else { return }
        selectedOption = index
    }

    func submit() {
        guard let selected = selectedOption, !isRevealed else { return }
        if selected == correctIndex {
            correctCount += 1
        }
        isRevealed = true
    }

    func advance() {
        guard isRevealed else { return }
        if isLastQuestion {
            isFinished = true
        } else {
            currentIndex += 1
            selectedOption = nil
            isRevealed = false
        }
    }

    func restart() {
        currentIndex = 0
        selectedOption = nil
        isRevealed = false
        correctCount = 0
        isFinished = false
    }
}
