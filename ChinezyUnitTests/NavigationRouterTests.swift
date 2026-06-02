//
//  NavigationRouterTests.swift
//  ChinezyUnitTests
//
//  Tests for NavigationRouter and related enums.
//

import XCTest
import SwiftUI
@testable import Chinezy

@MainActor
final class NavigationRouterTests: XCTestCase {

    var router: NavigationRouter!

    override func setUp() {
        super.setUp()
        router = NavigationRouter()
    }

    override func tearDown() {
        router = nil
        super.tearDown()
    }

    // MARK: - Default State

    func testDefaultState() {
        XCTAssertEqual(router.currentState, .unauthenticated)
        XCTAssertEqual(router.selectedTab, .materials)
        XCTAssertTrue(router.navigationPath.isEmpty)
        XCTAssertNil(router.selectedTheme)
        XCTAssertNil(router.selectedPart)
        XCTAssertFalse(router.showExercise)
    }

    // MARK: - navigateToHome

    func testNavigateToHome() {
        router.navigateToHome()
        XCTAssertEqual(router.currentState, .home)
    }

    // MARK: - Tab Selection

    func testSelectTab() {
        router.selectedTab = .quiz
        XCTAssertEqual(router.selectedTab, .quiz)

        router.selectedTab = .profile
        XCTAssertEqual(router.selectedTab, .profile)

        router.selectedTab = .tonePractice
        XCTAssertEqual(router.selectedTab, .tonePractice)

        router.selectedTab = .writing
        XCTAssertEqual(router.selectedTab, .writing)
    }

    // MARK: - navigateToCourse

    func testNavigateToCourse() {
        let course = Course(title: "Test", description: "D", icon: "T", subChapters: [])
        router.navigateToCourse(course: course)

        XCTAssertFalse(router.navigationPath.isEmpty)
        XCTAssertEqual(router.navigationPath.count, 1)
    }

    func testNavigateToMultipleCourses() {
        let c1 = Course(title: "A", description: "A", icon: "A", subChapters: [])
        let c2 = Course(title: "B", description: "B", icon: "B", subChapters: [])

        router.navigateToCourse(course: c1)
        router.navigateToCourse(course: c2)

        XCTAssertEqual(router.navigationPath.count, 2)
    }

    // MARK: - navigateToSubchapter

    func testNavigateToSubchapter() {
        let subChapter = SubChapter(title: "1.1", dialogLines: [])
        router.navigateToSubchapter(subChapter: subChapter)

        XCTAssertEqual(router.navigationPath.count, 1)
    }

    // MARK: - startExercise

    func testStartExercise() {
        let part = Part(name: "Part 1", characterCount: 10, progress: 0.5)
        router.startExercise(part: part)

        XCTAssertNotNil(router.selectedPart)
        XCTAssertEqual(router.selectedPart?.name, "Part 1")
        XCTAssertTrue(router.showExercise)
    }

    // MARK: - AppState Enum

    func testAppStateValues() {
        let unauthenticated = AppState.unauthenticated
        let home = AppState.home

        XCTAssertNotEqual(String(describing: unauthenticated), String(describing: home))
    }

    // MARK: - AppRoute Hashable

    func testAppRouteHashable() {
        let course = Course(title: "T", description: "D", icon: "I", subChapters: [])
        let route1 = AppRoute.course(course)
        let route2 = AppRoute.course(course)

        XCTAssertEqual(route1, route2)
    }

    func testAppRouteStaticCases() {
        let courseList = AppRoute.courseList
        let tonePractice = AppRoute.tonePractice
        let dictionary = AppRoute.dictionary
        let progress = AppRoute.progress

        // Just verify these can be created without crashing
        XCTAssertNotNil(courseList)
        XCTAssertNotNil(tonePractice)
        XCTAssertNotNil(dictionary)
        XCTAssertNotNil(progress)
    }
}
