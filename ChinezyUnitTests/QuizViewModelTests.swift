//
//  QuizViewModelTests.swift
//  ChinezyUnitTests
//
//  Comprehensive tests for QuizViewModel — the quiz session logic.
//

import XCTest
@testable import Chinezy

@MainActor
final class QuizViewModelTests: XCTestCase {

    /// Helper to create a Chapter with a known set of questions.
    private func makeSampleChapter(questionCount: Int = 3) -> Chapter {
        let questions = (0..<questionCount).map { i in
            QuizQuestion(
                id: i,
                type: "Test",
                stem: "Question \(i)",
                options: ["A", "B", "C", "D"],
                answerIndex: i % 4  // Correct answer rotates: 0, 1, 2, 0, 1, ...
            )
        }
        return Chapter(id: 1, title: "Test Chapter", hanzi: "测", questions: questions)
    }

    private func makeVM(questionCount: Int = 3) -> QuizViewModel {
        QuizViewModel(chapter: makeSampleChapter(questionCount: questionCount))
    }

    // MARK: - Initial State

    func testInitialState() {
        let vm = makeVM()

        XCTAssertEqual(vm.currentIndex, 0)
        XCTAssertNil(vm.selectedOption)
        XCTAssertFalse(vm.isRevealed)
        XCTAssertEqual(vm.correctCount, 0)
        XCTAssertFalse(vm.isFinished)
    }

    // MARK: - Derived Properties

    func testTotalQuestions() {
        XCTAssertEqual(makeVM(questionCount: 5).totalQuestions, 5)
        XCTAssertEqual(makeVM(questionCount: 1).totalQuestions, 1)
    }

    func testQuestionNumber() {
        let vm = makeVM()
        XCTAssertEqual(vm.questionNumber, 1) // 1-indexed
    }

    func testIsLastQuestion() {
        let vm = makeVM(questionCount: 1)
        XCTAssertTrue(vm.isLastQuestion)
    }

    func testIsNotLastQuestion() {
        let vm = makeVM(questionCount: 3)
        XCTAssertFalse(vm.isLastQuestion)
    }

    func testHasSelectionFalse() {
        let vm = makeVM()
        XCTAssertFalse(vm.hasSelection)
    }

    func testHasSelectionTrue() {
        let vm = makeVM()
        vm.select(0)
        XCTAssertTrue(vm.hasSelection)
    }

    func testCorrectIndex() {
        let vm = makeVM() // answerIndex for question 0 is 0
        XCTAssertEqual(vm.correctIndex, 0)
    }

    func testCorrectAnswerText() {
        let vm = makeVM() // answerIndex 0 -> options[0] = "A"
        XCTAssertEqual(vm.correctAnswerText, "A")
    }

    // MARK: - Progress

    func testProgressAtStart() {
        let vm = makeVM(questionCount: 4)
        XCTAssertEqual(vm.progress, 0.25, accuracy: 0.01)
    }

    func testProgressWithZeroQuestions() {
        let chapter = Chapter(id: 1, title: "Empty", hanzi: "空", questions: [])
        let vm = QuizViewModel(chapter: chapter)
        XCTAssertEqual(vm.progress, 0)
    }

    // MARK: - select()

    func testSelectSetsOption() {
        let vm = makeVM()
        vm.select(2)
        XCTAssertEqual(vm.selectedOption, 2)
    }

    func testSelectOverwrite() {
        let vm = makeVM()
        vm.select(1)
        vm.select(3)
        XCTAssertEqual(vm.selectedOption, 3)
    }

    func testSelectIgnoredAfterReveal() {
        let vm = makeVM()
        vm.select(0)
        vm.submit()

        vm.select(2) // Should be ignored
        XCTAssertEqual(vm.selectedOption, 0) // Still original
    }

    // MARK: - submit()

    func testSubmitCorrectAnswer() {
        let vm = makeVM() // Q0 answer is 0
        vm.select(0)
        vm.submit()

        XCTAssertTrue(vm.isRevealed)
        XCTAssertEqual(vm.correctCount, 1)
        XCTAssertTrue(vm.isCurrentCorrect)
    }

    func testSubmitWrongAnswer() {
        let vm = makeVM() // Q0 answer is 0
        vm.select(3)
        vm.submit()

        XCTAssertTrue(vm.isRevealed)
        XCTAssertEqual(vm.correctCount, 0)
        XCTAssertFalse(vm.isCurrentCorrect)
    }

    func testSubmitWithoutSelection() {
        let vm = makeVM()
        vm.submit() // No selection

        XCTAssertFalse(vm.isRevealed) // Should not reveal
    }

    func testSubmitTwiceDoesNotDouble() {
        let vm = makeVM()
        vm.select(0)
        vm.submit()
        vm.submit() // Second call should be ignored

        XCTAssertEqual(vm.correctCount, 1)
    }

    // MARK: - advance()

    func testAdvanceMoves() {
        let vm = makeVM(questionCount: 3)
        vm.select(0)
        vm.submit()
        vm.advance()

        XCTAssertEqual(vm.currentIndex, 1)
        XCTAssertNil(vm.selectedOption)
        XCTAssertFalse(vm.isRevealed)
        XCTAssertFalse(vm.isFinished)
    }

    func testAdvanceWithoutRevealDoesNothing() {
        let vm = makeVM()
        vm.advance() // Not revealed

        XCTAssertEqual(vm.currentIndex, 0)
    }

    func testAdvanceOnLastQuestionFinishes() {
        let vm = makeVM(questionCount: 1)
        vm.select(0)
        vm.submit()
        vm.advance()

        XCTAssertTrue(vm.isFinished)
    }

    func testCompleteFullQuiz() {
        let vm = makeVM(questionCount: 3)

        // Q0: correct (answerIndex: 0)
        vm.select(0)
        vm.submit()
        vm.advance()

        // Q1: wrong (answerIndex: 1)
        vm.select(0)
        vm.submit()
        vm.advance()

        // Q2: correct (answerIndex: 2)
        vm.select(2)
        vm.submit()
        vm.advance()

        XCTAssertTrue(vm.isFinished)
        XCTAssertEqual(vm.correctCount, 2)
        XCTAssertEqual(vm.wrongCount, 1)
        XCTAssertEqual(vm.scorePercentage, 67) // 2/3 ≈ 66.7 → 67
    }

    // MARK: - Score Properties

    func testWrongCount() {
        let vm = makeVM(questionCount: 2)
        vm.select(0) // Q0 correct (answerIndex: 0)
        vm.submit()
        vm.advance()

        vm.select(0) // Q1 wrong (answerIndex: 1)
        vm.submit()

        XCTAssertEqual(vm.wrongCount, 1)
    }

    func testScorePercentagePerfect() {
        let vm = makeVM(questionCount: 2)

        vm.select(0) // Q0 correct
        vm.submit()
        vm.advance()

        vm.select(1) // Q1 correct
        vm.submit()

        XCTAssertEqual(vm.scorePercentage, 100)
    }

    func testScorePercentageZero() {
        let vm = makeVM(questionCount: 1)
        vm.select(3) // Wrong (answerIndex: 0)
        vm.submit()

        XCTAssertEqual(vm.scorePercentage, 0)
    }

    func testScorePercentageZeroQuestions() {
        let chapter = Chapter(id: 1, title: "Empty", hanzi: "空", questions: [])
        let vm = QuizViewModel(chapter: chapter)
        XCTAssertEqual(vm.scorePercentage, 0)
    }

    // MARK: - restart()

    func testRestart() {
        let vm = makeVM(questionCount: 3)

        // Do some work
        vm.select(0)
        vm.submit()
        vm.advance()
        vm.select(1)
        vm.submit()

        // Restart
        vm.restart()

        XCTAssertEqual(vm.currentIndex, 0)
        XCTAssertNil(vm.selectedOption)
        XCTAssertFalse(vm.isRevealed)
        XCTAssertEqual(vm.correctCount, 0)
        XCTAssertFalse(vm.isFinished)
    }
}
