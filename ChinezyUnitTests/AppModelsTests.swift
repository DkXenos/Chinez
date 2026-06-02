//
//  AppModelsTests.swift
//  ChinezyUnitTests
//
//  Tests for Theme and Part models.
//

import XCTest
@testable import Chinezy

final class AppModelsTests: XCTestCase {

    // MARK: - Theme

    func testThemeInit() {
        let theme = Theme(name: "Animals", iconName: "pawprint", isLocked: false)

        XCTAssertEqual(theme.name, "Animals")
        XCTAssertEqual(theme.iconName, "pawprint")
        XCTAssertFalse(theme.isLocked)
        XCTAssertNotNil(theme.id)
    }

    func testThemeLockedState() {
        let locked = Theme(name: "Advanced", iconName: "lock", isLocked: true)
        let unlocked = Theme(name: "Basics", iconName: "star", isLocked: false)

        XCTAssertTrue(locked.isLocked)
        XCTAssertFalse(unlocked.isLocked)
    }

    func testThemeUniqueIds() {
        let t1 = Theme(name: "A", iconName: "a", isLocked: false)
        let t2 = Theme(name: "A", iconName: "a", isLocked: false)
        XCTAssertNotEqual(t1.id, t2.id)
    }

    // MARK: - Part

    func testPartInit() {
        let part = Part(name: "Part 1", characterCount: 15, progress: 0.75)

        XCTAssertEqual(part.name, "Part 1")
        XCTAssertEqual(part.characterCount, 15)
        XCTAssertEqual(part.progress, 0.75)
        XCTAssertNotNil(part.id)
    }

    func testPartProgressBounds() {
        let zero = Part(name: "P", characterCount: 0, progress: 0.0)
        let full = Part(name: "P", characterCount: 10, progress: 1.0)

        XCTAssertEqual(zero.progress, 0.0)
        XCTAssertEqual(full.progress, 1.0)
    }

    func testPartUniqueIds() {
        let p1 = Part(name: "Part 1", characterCount: 5, progress: 0.5)
        let p2 = Part(name: "Part 1", characterCount: 5, progress: 0.5)
        XCTAssertNotEqual(p1.id, p2.id)
    }

    // MARK: - ChapterTabOption

    func testChapterTabOptionAllCases() {
        let cases = ChapterTabOption.allCases
        XCTAssertEqual(cases.count, 3)
        XCTAssertTrue(cases.contains(.material))
        XCTAssertTrue(cases.contains(.quiz))
        XCTAssertTrue(cases.contains(.writing))
    }

    func testChapterTabOptionRawValues() {
        XCTAssertEqual(ChapterTabOption.material.rawValue, "Material")
        XCTAssertEqual(ChapterTabOption.quiz.rawValue, "Quiz")
        XCTAssertEqual(ChapterTabOption.writing.rawValue, "Writing")
    }

    func testChapterTabOptionIdentifiable() {
        let option = ChapterTabOption.material
        XCTAssertEqual(option.id, "Material")
    }
}
