//
//  ChinezyUnitTests.swift
//  ChinezyUnitTests
//
//  Created by Jason TIo on 02/06/26.
//  Entry-point test file — verifies the test bundle loads correctly.
//

import XCTest
@testable import Chinezy

final class ChinezyUnitTests: XCTestCase {

    /// Verifies that the test bundle can import the main app module.
    func testBundleLoads() {
        // If @testable import Chinezy above succeeds, the bundle is correctly linked.
        XCTAssertTrue(true, "Test bundle loaded and Chinezy module imported successfully.")
    }

    /// Verifies that the app's DesignSystem is accessible from the test target.
    func testDesignSystemAccessible() {
        let cornerRadius = DesignSystem.Dimensions.cornerRadius
        XCTAssertGreaterThan(cornerRadius, 0, "DesignSystem should be accessible from the test target.")
    }

    /// Verifies that core model types can be instantiated from the test target.
    func testCoreModelsAccessible() {
        let course = Course(title: "Test", description: "D", icon: "T", subChapters: [])
        XCTAssertEqual(course.title, "Test")

        let flashcard = Flashcard(hanzi: "你", pinyin: "nǐ", indonesianTranslation: "kamu", imageRef: nil, audioRef: nil)
        XCTAssertEqual(flashcard.hanzi, "你")

        let dialogLine = DialogLine(speaker: "A", text: "你好")
        XCTAssertEqual(dialogLine.speaker, "A")
    }
}
