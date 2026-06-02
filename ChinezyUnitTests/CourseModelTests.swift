//
//  CourseModelTests.swift
//  ChinezyUnitTests
//
//  Tests for Course, SubChapter, Flashcard, and DialogLine models.
//

import XCTest
@testable import Chinezy

final class CourseModelTests: XCTestCase {

    // MARK: - Flashcard

    func testFlashcardInit() {
        let card = Flashcard(
            hanzi: "你好",
            pinyin: "nǐ hǎo",
            indonesianTranslation: "halo",
            imageRef: "hand.wave.fill",
            audioRef: "nihao"
        )

        XCTAssertEqual(card.hanzi, "你好")
        XCTAssertEqual(card.pinyin, "nǐ hǎo")
        XCTAssertEqual(card.indonesianTranslation, "halo")
        XCTAssertEqual(card.imageRef, "hand.wave.fill")
        XCTAssertEqual(card.audioRef, "nihao")
    }

    func testFlashcardIdentifiable() {
        let card1 = Flashcard(hanzi: "我", pinyin: "wǒ", indonesianTranslation: "saya", imageRef: nil, audioRef: nil)
        let card2 = Flashcard(hanzi: "我", pinyin: "wǒ", indonesianTranslation: "saya", imageRef: nil, audioRef: nil)

        // Each flashcard gets a unique UUID
        XCTAssertNotEqual(card1.id, card2.id)
    }

    func testFlashcardWithNilOptionals() {
        let card = Flashcard(hanzi: "他", pinyin: "tā", indonesianTranslation: "dia", imageRef: nil, audioRef: nil)
        XCTAssertNil(card.imageRef)
        XCTAssertNil(card.audioRef)
    }

    func testFlashcardCodableRoundTrip() throws {
        let original = Flashcard(
            hanzi: "书", pinyin: "shū",
            indonesianTranslation: "buku",
            imageRef: "book.fill", audioRef: "shu"
        )
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Flashcard.self, from: data)

        XCTAssertEqual(decoded.hanzi, original.hanzi)
        XCTAssertEqual(decoded.pinyin, original.pinyin)
        XCTAssertEqual(decoded.indonesianTranslation, original.indonesianTranslation)
    }

    // MARK: - DialogLine

    func testDialogLineInit() {
        let line = DialogLine(speaker: "A", text: "你好！")
        XCTAssertEqual(line.speaker, "A")
        XCTAssertEqual(line.text, "你好！")
    }

    func testDialogLineEquatable() {
        let line1 = DialogLine(speaker: "A", text: "你好！")
        let line2 = DialogLine(speaker: "A", text: "你好！")
        let line3 = DialogLine(speaker: "B", text: "你好！")

        XCTAssertEqual(line1, line2)
        XCTAssertNotEqual(line1, line3)
    }

    func testDialogLineHashable() {
        let line1 = DialogLine(speaker: "A", text: "Hello")
        let line2 = DialogLine(speaker: "A", text: "Hello")

        var set = Set<DialogLine>()
        set.insert(line1)
        set.insert(line2)

        XCTAssertEqual(set.count, 1)
    }

    // MARK: - SubChapter

    func testSubChapterInit() {
        let subChapter = SubChapter(
            title: "1.1 Menyapa",
            flashcards: [
                Flashcard(hanzi: "你好", pinyin: "nǐ hǎo", indonesianTranslation: "halo", imageRef: nil, audioRef: nil)
            ],
            dialogLines: [
                DialogLine(speaker: "A", text: "你好！")
            ]
        )

        XCTAssertEqual(subChapter.title, "1.1 Menyapa")
        XCTAssertEqual(subChapter.flashcards.count, 1)
        XCTAssertEqual(subChapter.dialogLines.count, 1)
        XCTAssertEqual(subChapter.dialogAudioRef, "")
    }

    func testSubChapterIdentifiable() {
        let s1 = SubChapter(title: "A", dialogLines: [])
        let s2 = SubChapter(title: "A", dialogLines: [])
        XCTAssertNotEqual(s1.id, s2.id)
    }

    // MARK: - Course

    func testCourseInit() {
        let course = Course(
            title: "Bab 1: Perkenalan Diri",
            description: "Belajar menyapa",
            icon: "你",
            subChapters: []
        )

        XCTAssertEqual(course.title, "Bab 1: Perkenalan Diri")
        XCTAssertEqual(course.description, "Belajar menyapa")
        XCTAssertEqual(course.icon, "你")
        XCTAssertTrue(course.subChapters.isEmpty)
    }

    func testCourseWithSubChapters() {
        let sub1 = SubChapter(title: "1.1", dialogLines: [])
        let sub2 = SubChapter(title: "1.2", dialogLines: [])

        let course = Course(
            title: "Test",
            description: "Desc",
            icon: "T",
            subChapters: [sub1, sub2]
        )

        XCTAssertEqual(course.subChapters.count, 2)
        XCTAssertEqual(course.subChapters[0].title, "1.1")
        XCTAssertEqual(course.subChapters[1].title, "1.2")
    }

    func testCourseIdentifiable() {
        let c1 = Course(title: "A", description: "A", icon: "A", subChapters: [])
        let c2 = Course(title: "A", description: "A", icon: "A", subChapters: [])
        XCTAssertNotEqual(c1.id, c2.id)
    }

    func testCourseCodableRoundTrip() throws {
        let original = Course(
            title: "Test",
            description: "Desc",
            icon: "T",
            subChapters: [
                SubChapter(title: "1.1", dialogLines: [DialogLine(speaker: "A", text: "Hi")])
            ]
        )
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Course.self, from: data)

        XCTAssertEqual(decoded.title, original.title)
        XCTAssertEqual(decoded.subChapters.count, 1)
        XCTAssertEqual(decoded.subChapters[0].dialogLines.first?.text, "Hi")
    }
}
