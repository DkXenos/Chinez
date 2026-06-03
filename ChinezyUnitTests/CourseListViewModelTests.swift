//
//  CourseListViewModelTests.swift
//  ChinezyUnitTests
//
//  Tests for CourseListViewModel with mock CourseService.
//

import XCTest
@testable import Chinezy

// MARK: - Mock Service

private class MockCourseServiceForTests: CourseService {
    var coursesToReturn: [Course]

    init(courses: [Course]) {
        self.coursesToReturn = courses
    }

    func fetchCourses() -> [Course] {
        return coursesToReturn
    }
}

// MARK: - Tests

@MainActor
final class CourseListViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    private func makeSampleCourses() -> [Course] {
        [
            Course(title: "Bab 1: Perkenalan Diri", description: "Desc 1", icon: "你", subChapters: []),
            Course(title: "Bab 2: Asal Negara", description: "Desc 2", icon: "国", subChapters: []),
            Course(title: "Bab 3: Angka", description: "Desc 3", icon: "数", subChapters: [])
        ]
    }
    
    // MARK: - Helper

    // Helper to safely update search text and yield to the concurrency runtime
    private func setSearchTextAndWait(_ vm: CourseListViewModel, text: String) async {
        vm.searchText = text
        // Yield to allow any pending MainActor/Combine tasks to run before deallocation
        // This prevents the SIGABRT crash from Swift Concurrency internals.
        await Task.yield()
    }

    // MARK: - loadCourses

    func testLoadCourses() async throws {
        let service = MockCourseServiceForTests(courses: makeSampleCourses())
        let vm = CourseListViewModel(courseService: service)
        vm.loadCourses()

        XCTAssertEqual(vm.courses.count, 3)
        XCTAssertEqual(vm.courses[0].title, "Bab 1: Perkenalan Diri")
    }

    func testLoadCoursesEmpty() async throws {
        let service = MockCourseServiceForTests(courses: [])
        let vm = CourseListViewModel(courseService: service)
        vm.loadCourses()

        XCTAssertTrue(vm.courses.isEmpty)
    }

    // MARK: - filteredCourses — no search

    func testFilteredCoursesNoSearch() async throws {
        let service = MockCourseServiceForTests(courses: makeSampleCourses())
        let vm = CourseListViewModel(courseService: service)
        vm.loadCourses()

        XCTAssertEqual(vm.filteredCourses.count, 3)
    }

    // MARK: - filteredCourses — with search

    func testFilteredCoursesWithSearch() async throws {
        let service = MockCourseServiceForTests(courses: makeSampleCourses())
        let vm = CourseListViewModel(courseService: service)
        vm.loadCourses()

        await setSearchTextAndWait(vm, text: "Perkenalan")
        
        XCTAssertEqual(vm.filteredCourses.count, 1)
        XCTAssertEqual(vm.filteredCourses.first?.title, "Bab 1: Perkenalan Diri")
    }

    func testFilteredCoursesCaseInsensitive() async throws {
        let service = MockCourseServiceForTests(courses: makeSampleCourses())
        let vm = CourseListViewModel(courseService: service)
        vm.loadCourses()

        await setSearchTextAndWait(vm, text: "angka") // lowercase
        
        XCTAssertEqual(vm.filteredCourses.count, 1)
        XCTAssertEqual(vm.filteredCourses.first?.icon, "数")
    }

    func testFilteredCoursesNoMatch() async throws {
        let service = MockCourseServiceForTests(courses: makeSampleCourses())
        let vm = CourseListViewModel(courseService: service)
        vm.loadCourses()

        await setSearchTextAndWait(vm, text: "nonexistent")
        
        XCTAssertTrue(vm.filteredCourses.isEmpty)
    }

    func testFilteredCoursesPartialMatch() async throws {
        let service = MockCourseServiceForTests(courses: makeSampleCourses())
        let vm = CourseListViewModel(courseService: service)
        vm.loadCourses()

        await setSearchTextAndWait(vm, text: "Bab")
        
        XCTAssertEqual(vm.filteredCourses.count, 3)
    }

    func testFilteredCoursesEmptySearchShowsAll() async throws {
        let service = MockCourseServiceForTests(courses: makeSampleCourses())
        let vm = CourseListViewModel(courseService: service)
        vm.loadCourses()

        await setSearchTextAndWait(vm, text: "Perkenalan")
        XCTAssertEqual(vm.filteredCourses.count, 1)

        await setSearchTextAndWait(vm, text: "") // Clear search
        XCTAssertEqual(vm.filteredCourses.count, 3)
    }
}
