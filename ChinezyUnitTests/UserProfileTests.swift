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
            totalQuizzesCompleted: 5,
            completedChapters: ["ch1", "ch2"]
        )

        XCTAssertEqual(profile.id, "uid_123")
        XCTAssertEqual(profile.email, "test@example.com")
        XCTAssertEqual(profile.totalQuizzesCompleted, 5)
        XCTAssertEqual(profile.completedChapters, ["ch1", "ch2"])
    }

    // MARK: - Dictionary Initializer (valid)

    func testInitFromValidDictionary() {
        let dict: [String: Any] = [
            "id": "uid_456",
            "email": "user@mail.com",
            "totalQuizzesCompleted": 10,
            "completedChapters": ["ch3"]
        ]

        let profile = UserProfile(dictionary: dict)

        XCTAssertNotNil(profile)
        XCTAssertEqual(profile?.id, "uid_456")
        XCTAssertEqual(profile?.email, "user@mail.com")
        XCTAssertEqual(profile?.totalQuizzesCompleted, 10)
        XCTAssertEqual(profile?.completedChapters, ["ch3"])
    }

    // MARK: - Dictionary Initializer (invalid — missing keys)

    func testInitFromDictionaryMissingId() {
        let dict: [String: Any] = [
            "email": "user@mail.com",
            "totalQuizzesCompleted": 0,
            "completedChapters": []
        ]
        XCTAssertNil(UserProfile(dictionary: dict))
    }

    func testInitFromDictionaryMissingEmail() {
        let dict: [String: Any] = [
            "id": "uid_1",
            "totalQuizzesCompleted": 0,
            "completedChapters": []
        ]
        XCTAssertNil(UserProfile(dictionary: dict))
    }

    func testInitFromDictionaryMissingQuizzes() {
        let dict: [String: Any] = [
            "id": "uid_1",
            "email": "a@b.com",
            "completedChapters": []
        ]
        XCTAssertNil(UserProfile(dictionary: dict))
    }

    func testInitFromDictionaryMissingChapters() {
        let dict: [String: Any] = [
            "id": "uid_1",
            "email": "a@b.com",
            "totalQuizzesCompleted": 0
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
            totalQuizzesCompleted: 3,
            completedChapters: ["a", "b"]
        )

        let dict = original.dictionary
        let restored = UserProfile(dictionary: dict)

        XCTAssertNotNil(restored)
        XCTAssertEqual(restored?.id, original.id)
        XCTAssertEqual(restored?.email, original.email)
        XCTAssertEqual(restored?.totalQuizzesCompleted, original.totalQuizzesCompleted)
        XCTAssertEqual(restored?.completedChapters, original.completedChapters)
    }

    // MARK: - Wrong types

    func testInitFromDictionaryWrongTypes() {
        let dict: [String: Any] = [
            "id": 123,  // should be String
            "email": "a@b.com",
            "totalQuizzesCompleted": 0,
            "completedChapters": []
        ]
        XCTAssertNil(UserProfile(dictionary: dict))
    }
}
