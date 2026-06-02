//
//  ChapterListViewModelTests.swift
//  ChinezyUnitTests
//
//  Tests for ChapterListViewModel with mock QuizDataService.
//

import XCTest
@testable import Chinezy

// MARK: - Mock Service

private struct MockQuizDataService: QuizDataServiceProtocol {
    var chapters: [Chapter]
    var shouldThrow: Bool

    func loadChapters() throws -> [Chapter] {
        if shouldThrow {
            throw NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock load error"])
        }
        return chapters
    }
}

// MARK: - Tests

@MainActor
final class ChapterListViewModelTests: XCTestCase {

    func testLoadChaptersSuccess() {
        let mockChapters = [
            Chapter(id: 1, title: "Chapter 1", hanzi: "一", questions: []),
            Chapter(id: 2, title: "Chapter 2", hanzi: "二", questions: [])
        ]
        let service = MockQuizDataService(chapters: mockChapters, shouldThrow: false)
        let vm = ChapterListViewModel(service: service)

        XCTAssertEqual(vm.chapters.count, 2)
        XCTAssertEqual(vm.chapters[0].title, "Chapter 1")
        XCTAssertEqual(vm.chapters[1].title, "Chapter 2")
        XCTAssertNil(vm.errorMessage)
    }

    func testLoadChaptersEmpty() {
        let service = MockQuizDataService(chapters: [], shouldThrow: false)
        let vm = ChapterListViewModel(service: service)

        XCTAssertTrue(vm.chapters.isEmpty)
        XCTAssertNil(vm.errorMessage)
    }

    func testLoadChaptersError() {
        let service = MockQuizDataService(chapters: [], shouldThrow: true)
        let vm = ChapterListViewModel(service: service)

        XCTAssertTrue(vm.chapters.isEmpty)
        XCTAssertNotNil(vm.errorMessage)
        XCTAssertTrue(vm.errorMessage?.contains("Mock load error") ?? false)
    }

    func testReload() {
        let service = MockQuizDataService(
            chapters: [Chapter(id: 1, title: "Only", hanzi: "只", questions: [])],
            shouldThrow: false
        )
        let vm = ChapterListViewModel(service: service)

        XCTAssertEqual(vm.chapters.count, 1)

        // Calling load() again should re-populate
        vm.load()
        XCTAssertEqual(vm.chapters.count, 1)
        XCTAssertNil(vm.errorMessage)
    }
}
