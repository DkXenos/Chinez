//
//  WritingModelsTests.swift
//  ChinezyUnitTests
//
//  Tests for WritingExerciseData and WritingLevel models.
//

import XCTest
@testable import Chinezy

final class WritingModelsTests: XCTestCase {

    // MARK: - WritingLevel Properties

    func testWritingLevelProperties() {
        let level = WritingLevel(id: 1, title: "Angka Dasar", characters: ["一", "二", "三"])

        XCTAssertEqual(level.id, 1)
        XCTAssertEqual(level.title, "Angka Dasar")
        XCTAssertEqual(level.characters.count, 3)
    }

    func testWritingLevelCharacterCount() {
        let level = WritingLevel(id: 2, title: "Test", characters: ["四", "五"])
        XCTAssertEqual(level.characterCount, 2)
    }

    func testWritingLevelEmptyCharacters() {
        let level = WritingLevel(id: 3, title: "Empty", characters: [])
        XCTAssertEqual(level.characterCount, 0)
    }

    // MARK: - WritingLevel.sample (DEBUG fixture)

    func testWritingLevelSample() {
        let sample = WritingLevel.sample
        XCTAssertEqual(sample.id, 1)
        XCTAssertEqual(sample.title, "Angka Dasar")
        XCTAssertEqual(sample.characterCount, 5)
        XCTAssertEqual(sample.characters.first, "一")
        XCTAssertEqual(sample.characters.last, "五")
    }

    // MARK: - Codable Round-Trip

    func testWritingLevelCodableRoundTrip() throws {
        let original = WritingLevel(id: 10, title: "Hewan", characters: ["马", "牛"])
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(WritingLevel.self, from: data)

        XCTAssertEqual(decoded.id, original.id)
        XCTAssertEqual(decoded.title, original.title)
        XCTAssertEqual(decoded.characters, original.characters)
    }

    func testWritingExerciseDataCodableRoundTrip() throws {
        let exerciseData = WritingExerciseData(levels: [
            WritingLevel(id: 1, title: "A", characters: ["一"]),
            WritingLevel(id: 2, title: "B", characters: ["二"])
        ])

        let data = try JSONEncoder().encode(exerciseData)
        let decoded = try JSONDecoder().decode(WritingExerciseData.self, from: data)

        XCTAssertEqual(decoded.levels.count, 2)
        XCTAssertEqual(decoded.levels[0].title, "A")
        XCTAssertEqual(decoded.levels[1].title, "B")
    }

    // MARK: - Hashable

    func testWritingLevelHashable() {
        let l1 = WritingLevel(id: 1, title: "Test", characters: ["一"])
        let l2 = WritingLevel(id: 1, title: "Test", characters: ["一"])
        XCTAssertEqual(l1, l2)
    }

    // MARK: - Decodable from JSON String

    func testWritingExerciseDataDecodableFromJSON() throws {
        let json = """
        {
            "levels": [
                { "id": 1, "title": "Level 1", "characters": ["大", "小"] }
            ]
        }
        """.data(using: .utf8)!

        let decoded = try JSONDecoder().decode(WritingExerciseData.self, from: json)
        XCTAssertEqual(decoded.levels.count, 1)
        XCTAssertEqual(decoded.levels[0].characterCount, 2)
    }
}
