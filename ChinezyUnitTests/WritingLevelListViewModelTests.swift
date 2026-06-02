//
//  WritingLevelListViewModelTests.swift
//  ChinezyUnitTests
//
//  Tests for WritingLevelListViewModel with mock WritingDataService.
//

import XCTest
@testable import Chinezy

// MARK: - Mock Service

private struct MockWritingDataService: WritingDataServiceProtocol {
    var levels: [WritingLevel]
    var shouldThrow: Bool

    func loadLevels() throws -> [WritingLevel] {
        if shouldThrow {
            throw NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock writing error"])
        }
        return levels
    }
}

// MARK: - Tests

@MainActor
final class WritingLevelListViewModelTests: XCTestCase {

    func testLoadLevelsSuccess() {
        let mockLevels = [
            WritingLevel(id: 1, title: "Level 1", characters: ["一", "二"]),
            WritingLevel(id: 2, title: "Level 2", characters: ["三"])
        ]
        let service = MockWritingDataService(levels: mockLevels, shouldThrow: false)
        let vm = WritingLevelListViewModel(service: service)

        XCTAssertEqual(vm.levels.count, 2)
        XCTAssertEqual(vm.levels[0].title, "Level 1")
        XCTAssertNil(vm.errorMessage)
    }

    func testLoadLevelsEmpty() {
        let service = MockWritingDataService(levels: [], shouldThrow: false)
        let vm = WritingLevelListViewModel(service: service)

        XCTAssertTrue(vm.levels.isEmpty)
        XCTAssertNil(vm.errorMessage)
    }

    func testLoadLevelsError() {
        let service = MockWritingDataService(levels: [], shouldThrow: true)
        let vm = WritingLevelListViewModel(service: service)

        XCTAssertTrue(vm.levels.isEmpty)
        XCTAssertNotNil(vm.errorMessage)
        XCTAssertTrue(vm.errorMessage?.contains("Mock writing error") ?? false)
    }

    func testReload() {
        let service = MockWritingDataService(
            levels: [WritingLevel(id: 1, title: "Only", characters: ["四"])],
            shouldThrow: false
        )
        let vm = WritingLevelListViewModel(service: service)

        XCTAssertEqual(vm.levels.count, 1)

        vm.load()
        XCTAssertEqual(vm.levels.count, 1)
        XCTAssertNil(vm.errorMessage)
    }
}
