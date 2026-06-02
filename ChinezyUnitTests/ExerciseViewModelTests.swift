//
//  ExerciseViewModelTests.swift
//  ChinezyUnitTests
//
//  Tests for ExerciseViewModel.
//

import XCTest
@testable import Chinezy

final class ExerciseViewModelTests: XCTestCase {

    // MARK: - Default Init

    func testDefaultInit() {
        let vm = ExerciseViewModel()

        XCTAssertEqual(vm.charactersToLearn, ["我", "是", "中", "国", "人"])
        XCTAssertEqual(vm.currentIndex, 0)
        XCTAssertEqual(vm.mistakeCount, 0)
        XCTAssertFalse(vm.isQuizComplete)
    }

    // MARK: - Custom Init

    func testCustomInit() {
        let vm = ExerciseViewModel(characters: ["一", "二", "三"])

        XCTAssertEqual(vm.charactersToLearn, ["一", "二", "三"])
        XCTAssertEqual(vm.currentIndex, 0)
    }

    // MARK: - currentCharacter

    func testCurrentCharacter() {
        let vm = ExerciseViewModel(characters: ["大", "小"])
        XCTAssertEqual(vm.currentCharacter, "大")
    }

    func testCurrentCharacterAfterAdvance() {
        let vm = ExerciseViewModel(characters: ["大", "小"])
        vm.characterCompleted()
        XCTAssertEqual(vm.currentCharacter, "小")
    }

    func testCurrentCharacterPastEnd() {
        let vm = ExerciseViewModel(characters: ["大"])
        vm.characterCompleted()
        XCTAssertEqual(vm.currentCharacter, "") // index out of bounds → ""
    }

    // MARK: - characterCompleted

    func testCharacterCompletedAdvancesIndex() {
        let vm = ExerciseViewModel(characters: ["一", "二", "三"])
        vm.characterCompleted()

        XCTAssertEqual(vm.currentIndex, 1)
        XCTAssertFalse(vm.isQuizComplete)
    }

    func testCharacterCompletedFinishesQuiz() {
        let vm = ExerciseViewModel(characters: ["一"])
        vm.characterCompleted()

        XCTAssertEqual(vm.currentIndex, 1)
        XCTAssertTrue(vm.isQuizComplete)
    }

    func testCompleteAllCharacters() {
        let vm = ExerciseViewModel(characters: ["一", "二", "三"])

        vm.characterCompleted()
        XCTAssertFalse(vm.isQuizComplete)

        vm.characterCompleted()
        XCTAssertFalse(vm.isQuizComplete)

        vm.characterCompleted()
        XCTAssertTrue(vm.isQuizComplete)
    }

    // MARK: - registerMistake

    func testRegisterMistake() {
        let vm = ExerciseViewModel()

        vm.registerMistake()
        XCTAssertEqual(vm.mistakeCount, 1)

        vm.registerMistake()
        XCTAssertEqual(vm.mistakeCount, 2)

        vm.registerMistake()
        XCTAssertEqual(vm.mistakeCount, 3)
    }

    // MARK: - Combined Flow

    func testFullExerciseFlow() {
        let vm = ExerciseViewModel(characters: ["大", "小"])

        // Start
        XCTAssertEqual(vm.currentCharacter, "大")
        XCTAssertEqual(vm.mistakeCount, 0)

        // Make mistakes on first character
        vm.registerMistake()
        vm.registerMistake()
        XCTAssertEqual(vm.mistakeCount, 2)

        // Complete first character
        vm.characterCompleted()
        XCTAssertEqual(vm.currentCharacter, "小")
        XCTAssertFalse(vm.isQuizComplete)

        // Complete second character
        vm.characterCompleted()
        XCTAssertTrue(vm.isQuizComplete)
        XCTAssertEqual(vm.mistakeCount, 2) // Mistakes persist
    }
}
