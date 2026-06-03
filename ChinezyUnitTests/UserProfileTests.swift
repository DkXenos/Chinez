//
//  UserProfileTests.swift
//  ChinezyUnitTests
//
//  Tests for the UserProfile model.
//

import XCTest
@testable import Chinezy

final class UserProfileTests: XCTestCase {

    // MARK: - Memberwise Initializer

    func testMemberwiseInit() {
        let profile = UserProfile(
            id: "uid_123",
            email: "test@example.com",
            quizScores: ["quiz1": 80, "quiz2": 100]
        )

        XCTAssertEqual(profile.id, "uid_123")
        XCTAssertEqual(profile.email, "test@example.com")
        XCTAssertEqual(profile.quizScores, ["quiz1": 80, "quiz2": 100])
    }

    // MARK: - Dictionary Initializer (valid)

    func testInitFromValidDictionary() {
        let dict: [String: Any] = [
            "id": "uid_456",
            "email": "user@mail.com",
            "quizScores": ["quiz3": 95]
        ]

        let profile = UserProfile(dictionary: dict)

        XCTAssertNotNil(profile)
        XCTAssertEqual(profile?.id, "uid_456")
        XCTAssertEqual(profile?.email, "user@mail.com")
        XCTAssertEqual(profile?.quizScores, ["quiz3": 95])
    }

    // MARK: - Dictionary Initializer (invalid — missing keys)

    func testInitFromDictionaryMissingId() {
        let dict: [String: Any] = [
            "email": "user@mail.com",
            "quizScores": ["quiz1": 100]
        ]
        XCTAssertNil(UserProfile(dictionary: dict))
    }

    func testInitFromDictionaryMissingEmail() {
        let dict: [String: Any] = [
            "id": "uid_1",
            "quizScores": ["quiz1": 100]
        ]
        XCTAssertNil(UserProfile(dictionary: dict))
    }

    func testInitFromEmptyDictionary() {
        XCTAssertNil(UserProfile(dictionary: [:]))
    }

    // MARK: - Dictionary Property Round-Trip

    func testDictionaryRoundTrip() {
        let original = UserProfile(
            id: "round_trip",
            email: "rt@test.com",
            quizScores: ["q1": 70, "q2": 100]
        )

        let dict = original.dictionary
        let restored = UserProfile(dictionary: dict)

        XCTAssertNotNil(restored)
        XCTAssertEqual(restored?.id, original.id)
        XCTAssertEqual(restored?.email, original.email)
        XCTAssertEqual(restored?.quizScores, original.quizScores)
    }

    // MARK: - Wrong types

    func testInitFromDictionaryWrongTypes() {
        let dict: [String: Any] = [
            "id": 123,  // should be String
            "email": "a@b.com",
            "quizScores": ["quiz1": "100"] // should be [String: Int]
        ]
        
        let profile = UserProfile(dictionary: dict)
        // With current dictionary initializer, if quizScores fails to cast to [String: Int], it defaults to [:]
        // But if id is missing/wrong type, it fails completely.
        XCTAssertNil(profile)
    }
}
