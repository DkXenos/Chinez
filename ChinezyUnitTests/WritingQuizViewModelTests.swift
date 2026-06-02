//
//  WritingQuizViewModelTests.swift
//  ChinezyUnitTests
//
//  Tests for WritingQuizViewModel.
//

import XCTest
@testable import Chinezy

@MainActor
final class WritingQuizViewModelTests: XCTestCase {

    private func makeVM() -> WritingQuizViewModel {
        let level = WritingLevel(id: 1, title: "Angka", characters: ["一", "二", "三", "四", "五"])
        return WritingQuizViewModel(level: level)
    }

    // MARK: - Initial State

    func testInitialState() {
        let vm = makeVM()
        XCTAssertEqual(vm.currentIndex, 0)
        XCTAssertEqual(vm.currentCharacter, "")  // Empty until onAppear
        XCTAssertFalse(vm.showSuccessBanner)
        XCTAssertEqual(vm.mistakeCount, 0)
        XCTAssertEqual(vm.correctStrokesInChar, 0)
    }

    // MARK: - onAppear

    func testOnAppearSetsFirstCharacter() {
        let vm = makeVM()
        vm.onAppear()
        XCTAssertEqual(vm.currentCharacter, "一")
    }

    func testOnAppearDoesNotOverwrite() {
        let vm = makeVM()
        vm.currentCharacter = "二"
        vm.onAppear()
        XCTAssertEqual(vm.currentCharacter, "二") // Should not overwrite
    }

    func testOnAppearWithEmptyLevel() {
        let level = WritingLevel(id: 1, title: "Empty", characters: [])
        let vm = WritingQuizViewModel(level: level)
        vm.onAppear()
        XCTAssertEqual(vm.currentCharacter, "")
    }

    // MARK: - handleMistake

    func testHandleMistakeIncrements() {
        let vm = makeVM()
        XCTAssertEqual(vm.mistakeCount, 0)

        vm.handleMistake()
        XCTAssertEqual(vm.mistakeCount, 1)

        vm.handleMistake()
        XCTAssertEqual(vm.mistakeCount, 2)
    }

    // MARK: - handleCorrectStroke

    func testHandleCorrectStroke() {
        let vm = makeVM()
        vm.handleCorrectStroke(0)
        XCTAssertEqual(vm.correctStrokesInChar, 1)

        vm.handleCorrectStroke(1)
        XCTAssertEqual(vm.correctStrokesInChar, 2)
    }

    // MARK: - Level Properties

    func testLevelReference() {
        let vm = makeVM()
        XCTAssertEqual(vm.level.title, "Angka")
        XCTAssertEqual(vm.level.characters.count, 5)
    }
}
