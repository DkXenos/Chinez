//
//  LearningViewModelTests.swift
//  ChinezyUnitTests
//
//  Tests for LearningViewModel.
//

import XCTest
@testable import Chinezy

final class LearningViewModelTests: XCTestCase {

    /// Helper to create a SubChapter with flashcards.
    private func makeSampleSubChapter(flashcardCount: Int = 3) -> SubChapter {
        let flashcards = (0..<flashcardCount).map { i in
            Flashcard(
                hanzi: "字\(i)",
                pinyin: "zì\(i)",
                indonesianTranslation: "char \(i)",
                imageRef: nil,
                audioRef: nil
            )
        }
        return SubChapter(
            title: "Test Sub",
            flashcards: flashcards,
            dialogLines: [
                DialogLine(speaker: "A", text: "你好"),
                DialogLine(speaker: "B", text: "你好！")
            ]
        )
    }

    // MARK: - startLearning

    func testStartLearningSetsSubChapter() {
        let vm = LearningViewModel()
        let sub = makeSampleSubChapter()
        vm.startLearning(subChapter: sub)

        XCTAssertNotNil(vm.currentSubChapter)
        XCTAssertEqual(vm.currentSubChapter?.title, "Test Sub")
        XCTAssertEqual(vm.currentFlashcardIndex, 0)
        XCTAssertFalse(vm.isCardFlipped)
        XCTAssertFalse(vm.isShowingDialog)
    }

    func testStartLearningResetsState() {
        let vm = LearningViewModel()
        let sub = makeSampleSubChapter()

        // Set some state
        vm.startLearning(subChapter: sub)
        vm.flipCard()
        vm.goToNextFlashcard()

        // Restart with new subchapter
        let sub2 = makeSampleSubChapter(flashcardCount: 2)
        vm.startLearning(subChapter: sub2)

        XCTAssertEqual(vm.currentFlashcardIndex, 0)
        XCTAssertFalse(vm.isCardFlipped)
        XCTAssertFalse(vm.isShowingDialog)
    }

    // MARK: - currentFlashcard

    func testCurrentFlashcard() {
        let vm = LearningViewModel()
        let sub = makeSampleSubChapter()
        vm.startLearning(subChapter: sub)

        XCTAssertNotNil(vm.currentFlashcard)
        XCTAssertEqual(vm.currentFlashcard?.hanzi, "字0")
    }

    func testCurrentFlashcardNilWithoutSubChapter() {
        let vm = LearningViewModel()
        XCTAssertNil(vm.currentFlashcard)
    }

    // MARK: - flipCard

    func testFlipCard() {
        let vm = LearningViewModel()
        XCTAssertFalse(vm.isCardFlipped)

        vm.flipCard()
        XCTAssertTrue(vm.isCardFlipped)

        vm.flipCard()
        XCTAssertFalse(vm.isCardFlipped)
    }

    // MARK: - goToNextFlashcard

    func testGoToNextFlashcard() {
        let vm = LearningViewModel()
        vm.startLearning(subChapter: makeSampleSubChapter())
        vm.flipCard() // Flip first

        vm.goToNextFlashcard()

        XCTAssertEqual(vm.currentFlashcardIndex, 1)
        XCTAssertFalse(vm.isCardFlipped) // Reset on advance
        XCTAssertEqual(vm.currentFlashcard?.hanzi, "字1")
    }

    func testGoToNextFlashcardAtEnd() {
        let vm = LearningViewModel()
        vm.startLearning(subChapter: makeSampleSubChapter(flashcardCount: 1))

        vm.goToNextFlashcard() // Already on last, should not advance
        XCTAssertEqual(vm.currentFlashcardIndex, 0)
    }

    func testGoToNextFlashcardWithoutSubChapter() {
        let vm = LearningViewModel()
        vm.goToNextFlashcard() // Should not crash
        XCTAssertEqual(vm.currentFlashcardIndex, 0)
    }

    // MARK: - goToPreviousFlashcard

    func testGoToPreviousFlashcard() {
        let vm = LearningViewModel()
        vm.startLearning(subChapter: makeSampleSubChapter())
        vm.goToNextFlashcard() // Move to index 1

        vm.goToPreviousFlashcard()

        XCTAssertEqual(vm.currentFlashcardIndex, 0)
        XCTAssertFalse(vm.isCardFlipped)
    }

    func testGoToPreviousFlashcardAtStart() {
        let vm = LearningViewModel()
        vm.startLearning(subChapter: makeSampleSubChapter())

        vm.goToPreviousFlashcard() // Already at 0
        XCTAssertEqual(vm.currentFlashcardIndex, 0)
    }

    func testGoToPreviousFlashcardClosesDialog() {
        let vm = LearningViewModel()
        vm.startLearning(subChapter: makeSampleSubChapter())
        vm.openDialog()

        XCTAssertTrue(vm.isShowingDialog)
        vm.goToPreviousFlashcard() // Should close dialog first
        XCTAssertFalse(vm.isShowingDialog)
    }

    // MARK: - isOnLastFlashcard

    func testIsOnLastFlashcardTrue() {
        let vm = LearningViewModel()
        vm.startLearning(subChapter: makeSampleSubChapter(flashcardCount: 2))
        vm.goToNextFlashcard()

        XCTAssertTrue(vm.isOnLastFlashcard)
    }

    func testIsOnLastFlashcardFalse() {
        let vm = LearningViewModel()
        vm.startLearning(subChapter: makeSampleSubChapter(flashcardCount: 3))

        XCTAssertFalse(vm.isOnLastFlashcard)
    }

    func testIsOnLastFlashcardWithoutSubChapter() {
        let vm = LearningViewModel()
        XCTAssertFalse(vm.isOnLastFlashcard)
    }

    // MARK: - openDialog

    func testOpenDialog() {
        let vm = LearningViewModel()
        vm.startLearning(subChapter: makeSampleSubChapter())

        vm.openDialog()
        XCTAssertTrue(vm.isShowingDialog)
    }

    // MARK: - stopAudio

    func testStopAudio() {
        let vm = LearningViewModel()
        vm.startLearning(subChapter: makeSampleSubChapter())

        vm.stopAudio()
        XCTAssertFalse(vm.isPlayingDialog)
    }
}
