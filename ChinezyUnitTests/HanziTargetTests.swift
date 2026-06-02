//
//  HanziTargetTests.swift
//  ChinezyUnitTests
//
//  Tests for HanziTarget and ToneGroup models.
//

import XCTest
@testable import Chinezy

final class HanziTargetTests: XCTestCase {

    // MARK: - HanziTarget Init

    func testHanziTargetInit() {
        let target = HanziTarget(character: "妈", pinyin: "mā", targetTone: "Tone_1")

        XCTAssertEqual(target.character, "妈")
        XCTAssertEqual(target.pinyin, "mā")
        XCTAssertEqual(target.targetTone, "Tone_1")
        XCTAssertNotNil(target.id)
    }

    // MARK: - toneNumber Computed Property

    func testToneNumberTone1() {
        let target = HanziTarget(character: "妈", pinyin: "mā", targetTone: "Tone_1")
        XCTAssertEqual(target.toneNumber, 1)
    }

    func testToneNumberTone2() {
        let target = HanziTarget(character: "麻", pinyin: "má", targetTone: "Tone_2")
        XCTAssertEqual(target.toneNumber, 2)
    }

    func testToneNumberTone3() {
        let target = HanziTarget(character: "马", pinyin: "mǎ", targetTone: "Tone_3")
        XCTAssertEqual(target.toneNumber, 3)
    }

    func testToneNumberTone4() {
        let target = HanziTarget(character: "骂", pinyin: "mà", targetTone: "Tone_4")
        XCTAssertEqual(target.toneNumber, 4)
    }

    func testToneNumberUnknown() {
        let target = HanziTarget(character: "X", pinyin: "x", targetTone: "Noise")
        XCTAssertNil(target.toneNumber)
    }

    func testToneNumberEmptyString() {
        let target = HanziTarget(character: "X", pinyin: "x", targetTone: "")
        XCTAssertNil(target.toneNumber)
    }

    // MARK: - Identifiable / Hashable

    func testHanziTargetUniqueIds() {
        let t1 = HanziTarget(character: "妈", pinyin: "mā", targetTone: "Tone_1")
        let t2 = HanziTarget(character: "妈", pinyin: "mā", targetTone: "Tone_1")
        XCTAssertNotEqual(t1.id, t2.id)
    }

    // MARK: - HanziTarget.defaults

    func testDefaultsNotEmpty() {
        XCTAssertFalse(HanziTarget.defaults.isEmpty)
    }

    func testDefaultsContainAllTones() {
        let tones = Set(HanziTarget.defaults.compactMap { $0.toneNumber })
        XCTAssertTrue(tones.contains(1))
        XCTAssertTrue(tones.contains(2))
        XCTAssertTrue(tones.contains(3))
        XCTAssertTrue(tones.contains(4))
    }

    // MARK: - ToneGroup

    func testToneGroupInit() {
        let targets = [
            HanziTarget(character: "妈", pinyin: "mā", targetTone: "Tone_1"),
            HanziTarget(character: "他", pinyin: "tā", targetTone: "Tone_1")
        ]
        let group = ToneGroup(
            toneNumber: 1,
            title: "Tone 1",
            description: "Flat pitch",
            icon: "minus",
            targets: targets
        )

        XCTAssertEqual(group.toneNumber, 1)
        XCTAssertEqual(group.title, "Tone 1")
        XCTAssertEqual(group.targets.count, 2)
        XCTAssertNotNil(group.id)
    }

    // MARK: - ToneGroup.allGroups

    func testAllGroupsHasFourGroups() {
        XCTAssertEqual(ToneGroup.allGroups.count, 4)
    }

    func testAllGroupsEachNonEmpty() {
        for group in ToneGroup.allGroups {
            XCTAssertFalse(group.targets.isEmpty, "ToneGroup \(group.toneNumber) should have targets")
        }
    }

    func testAllGroupsToneNumbers() {
        let toneNumbers = ToneGroup.allGroups.map { $0.toneNumber }
        XCTAssertEqual(toneNumbers, [1, 2, 3, 4])
    }

    func testAllGroupsTargetTonesMatch() {
        for group in ToneGroup.allGroups {
            let expectedTone = "Tone_\(group.toneNumber)"
            for target in group.targets {
                XCTAssertEqual(target.targetTone, expectedTone,
                    "Target \(target.character) in group \(group.toneNumber) has wrong tone \(target.targetTone)")
            }
        }
    }
}
