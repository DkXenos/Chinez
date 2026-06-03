//
//  CourseListViewModelTests.swift
//  ChinezyUnitTests
//
//  Tests for CourseListViewModel with mock CourseService.
//

import XCTest
import Combine
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

final class CourseListViewModelTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
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

    // Helper to safely update search text and wait for Combine to process
    private func setSearchTextAndWait(_ vm: CourseListViewModel, text: String) {
        let expectation = XCTestExpectation(description: "Wait for Combine to process search text")
        
        vm.$searchText
            .dropFirst()
            .sink { _ in
                // Fulfill asynchronously to ensure Combine finishes all in-flight broadcasts 
                // before the test scope ends and the ViewModel is deallocated (prevents SIGABRT).
                DispatchQueue.main.async {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
            
        vm.searchText = text
        wait(for: [expectation], timeout: 2.0)
    }

    // MARK: - loadCourses

    func testLoadCourses() {
        let service = MockCourseServiceForTests(courses: makeSampleCourses())
        let vm = CourseListViewModel(courseService: service)
        vm.loadCourses()

        XCTAssertEqual(vm.courses.count, 3)
        XCTAssertEqual(vm.courses[0].title, "Bab 1: Perkenalan Diri")
    }

    func testLoadCoursesEmpty() {
        let service = MockCourseServiceForTests(courses: [])
        let vm = CourseListViewModel(courseService: service)
        vm.loadCourses()

        XCTAssertTrue(vm.courses.isEmpty)
    }

    // MARK: - filteredCourses — no search

    func testFilteredCoursesNoSearch() {
        let service = MockCourseServiceForTests(courses: makeSampleCourses())
        let vm = CourseListViewModel(courseService: service)
        vm.loadCourses()

        XCTAssertEqual(vm.filteredCourses.count, 3)
    }

    // MARK: - filteredCourses — with search

    func testFilteredCoursesWithSearch() {
        let service = MockCourseServiceForTests(courses: makeSampleCourses())
        let vm = CourseListViewModel(courseService: service)
        vm.loadCourses()

        setSearchTextAndWait(vm, text: "Perkenalan")
        
        XCTAssertEqual(vm.filteredCourses.count, 1)
        XCTAssertEqual(vm.filteredCourses.first?.title, "Bab 1: Perkenalan Diri")
    }

    func testFilteredCoursesCaseInsensitive() {
        let service = MockCourseServiceForTests(courses: makeSampleCourses())
        let vm = CourseListViewModel(courseService: service)
        vm.loadCourses()

        setSearchTextAndWait(vm, text: "angka") // lowercase
        
        XCTAssertEqual(vm.filteredCourses.count, 1)
        XCTAssertEqual(vm.filteredCourses.first?.icon, "数")
    }

    func testFilteredCoursesNoMatch() {
        let service = MockCourseServiceForTests(courses: makeSampleCourses())
        let vm = CourseListViewModel(courseService: service)
        vm.loadCourses()

        setSearchTextAndWait(vm, text: "nonexistent")
        
        XCTAssertTrue(vm.filteredCourses.isEmpty)
    }

    func testFilteredCoursesPartialMatch() {
        let service = MockCourseServiceForTests(courses: makeSampleCourses())
        let vm = CourseListViewModel(courseService: service)
        vm.loadCourses()

        setSearchTextAndWait(vm, text: "Bab")
        
        XCTAssertEqual(vm.filteredCourses.count, 3)
    }

    func testFilteredCoursesEmptySearchShowsAll() {
        let service = MockCourseServiceForTests(courses: makeSampleCourses())
        let vm = CourseListViewModel(courseService: service)
        vm.loadCourses()

        setSearchTextAndWait(vm, text: "Perkenalan")
        XCTAssertEqual(vm.filteredCourses.count, 1)

        setSearchTextAndWait(vm, text: "") // Clear search
        XCTAssertEqual(vm.filteredCourses.count, 3)
    }
}
