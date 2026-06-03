//
//  ExerciseViewModelTests.swift
//  ChinezyUnitTests
//
//  Tests for ExerciseViewModel.
//

import XCTest
@testable import Chinezy

@MainActor
final class ExerciseViewModelTests: XCTestCase {

    // MARK: - Default Init

    func testDefaultInit() async throws {
        let vm = ExerciseViewModel()

        XCTAssertEqual(vm.charactersToLearn, ["我", "是", "中", "国", "人"])
        XCTAssertEqual(vm.currentIndex, 0)
        XCTAssertEqual(vm.mistakeCount, 0)
        XCTAssertFalse(vm.isQuizComplete)
    }

    // MARK: - Custom Init

    func testCustomInit() async throws {
        let vm = ExerciseViewModel(characters: ["一", "二", "三"])

        XCTAssertEqual(vm.charactersToLearn, ["一", "二", "三"])
        XCTAssertEqual(vm.currentIndex, 0)
    }

    // MARK: - currentCharacter

    func testCurrentCharacter() async throws {
        let vm = ExerciseViewModel(characters: ["大", "小"])
        XCTAssertEqual(vm.currentCharacter, "大")
    }

    func testCurrentCharacterAfterAdvance() async throws {
        let vm = ExerciseViewModel(characters: ["大", "小"])
        vm.characterCompleted()
        await Task.yield()
        XCTAssertEqual(vm.currentCharacter, "小")
        
        // Wait for any async updateTask to finish before deallocation
        _ = await vm.updateTask?.result
    }

    func testCurrentCharacterPastEnd() async throws {
        let vm = ExerciseViewModel(characters: ["大"])
        vm.characterCompleted()
        await Task.yield()
        XCTAssertEqual(vm.currentCharacter, "") // index out of bounds → ""
        
        // Wait for any async updateTask to finish before deallocation
        _ = await vm.updateTask?.result
    }

    // MARK: - characterCompleted

    func testCharacterCompletedAdvancesIndex() async throws {
        let vm = ExerciseViewModel(characters: ["一", "二", "三"])
        vm.characterCompleted()
        await Task.yield()

        XCTAssertEqual(vm.currentIndex, 1)
        XCTAssertFalse(vm.isQuizComplete)
        
        _ = await vm.updateTask?.result
    }

    func testCharacterCompletedFinishesQuiz() async throws {
        let vm = ExerciseViewModel(characters: ["一"])
        vm.characterCompleted()
        await Task.yield()

        XCTAssertEqual(vm.currentIndex, 1)
        XCTAssertTrue(vm.isQuizComplete)
        
        _ = await vm.updateTask?.result
    }

    func testCompleteAllCharacters() async throws {
        let vm = ExerciseViewModel(characters: ["一", "二", "三"])

        vm.characterCompleted()
        await Task.yield()
        XCTAssertFalse(vm.isQuizComplete)

        vm.characterCompleted()
        await Task.yield()
        XCTAssertFalse(vm.isQuizComplete)

        vm.characterCompleted()
        await Task.yield()
        XCTAssertTrue(vm.isQuizComplete)
        
        _ = await vm.updateTask?.result
    }

    // MARK: - registerMistake

    func testRegisterMistake() async throws {
        let vm = ExerciseViewModel()

        vm.registerMistake()
        await Task.yield()
        XCTAssertEqual(vm.mistakeCount, 1)

        vm.registerMistake()
        await Task.yield()
        XCTAssertEqual(vm.mistakeCount, 2)

        vm.registerMistake()
        await Task.yield()
        XCTAssertEqual(vm.mistakeCount, 3)
        
        _ = await vm.updateTask?.result
    }

    // MARK: - Combined Flow

    func testFullExerciseFlow() async throws {
        let vm = ExerciseViewModel(characters: ["大", "小"])

        // Start
        XCTAssertEqual(vm.currentCharacter, "大")
        XCTAssertEqual(vm.mistakeCount, 0)

        // Make mistakes on first character
        vm.registerMistake()
        vm.registerMistake()
        await Task.yield()
        XCTAssertEqual(vm.mistakeCount, 2)

        // Complete first character
        vm.characterCompleted()
        await Task.yield()
        XCTAssertEqual(vm.currentCharacter, "小")
        XCTAssertFalse(vm.isQuizComplete)

        // Complete second character
        vm.characterCompleted()
        await Task.yield()
        XCTAssertTrue(vm.isQuizComplete)
        XCTAssertEqual(vm.mistakeCount, 2) // Mistakes persist
        
        _ = await vm.updateTask?.result
    }
}
