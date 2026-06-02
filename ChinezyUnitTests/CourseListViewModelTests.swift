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

final class CourseListViewModelTests: XCTestCase {

    private func makeSampleCourses() -> [Course] {
        [
            Course(title: "Bab 1: Perkenalan Diri", description: "Desc 1", icon: "你", subChapters: []),
            Course(title: "Bab 2: Asal Negara", description: "Desc 2", icon: "国", subChapters: []),
            Course(title: "Bab 3: Angka", description: "Desc 3", icon: "数", subChapters: [])
        ]
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

        vm.searchText = "Perkenalan"
        XCTAssertEqual(vm.filteredCourses.count, 1)
        XCTAssertEqual(vm.filteredCourses.first?.title, "Bab 1: Perkenalan Diri")
    }

    func testFilteredCoursesCaseInsensitive() {
        let service = MockCourseServiceForTests(courses: makeSampleCourses())
        let vm = CourseListViewModel(courseService: service)
        vm.loadCourses()

        vm.searchText = "angka" // lowercase
        XCTAssertEqual(vm.filteredCourses.count, 1)
        XCTAssertEqual(vm.filteredCourses.first?.icon, "数")
    }

    func testFilteredCoursesNoMatch() {
        let service = MockCourseServiceForTests(courses: makeSampleCourses())
        let vm = CourseListViewModel(courseService: service)
        vm.loadCourses()

        vm.searchText = "nonexistent"
        XCTAssertTrue(vm.filteredCourses.isEmpty)
    }

    func testFilteredCoursesPartialMatch() {
        let service = MockCourseServiceForTests(courses: makeSampleCourses())
        let vm = CourseListViewModel(courseService: service)
        vm.loadCourses()

        vm.searchText = "Bab"
        XCTAssertEqual(vm.filteredCourses.count, 3)
    }

    func testFilteredCoursesEmptySearchShowsAll() {
        let service = MockCourseServiceForTests(courses: makeSampleCourses())
        let vm = CourseListViewModel(courseService: service)
        vm.loadCourses()

        vm.searchText = "Perkenalan"
        XCTAssertEqual(vm.filteredCourses.count, 1)

        vm.searchText = "" // Clear search
        XCTAssertEqual(vm.filteredCourses.count, 3)
    }
}
