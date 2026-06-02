//
//  QuizModelsTests.swift
//  ChinezyUnitTests
//
//  Tests for QuizData, Chapter, and QuizQuestion models.
//

import XCTest
@testable import Chinezy

final class QuizModelsTests: XCTestCase {

    // MARK: - QuizQuestion

    func testQuizQuestionProperties() {
        let q = QuizQuestion(
            id: 1,
            type: "Hanzi → Arti",
            stem: "Apa arti 老师 ?",
            options: ["murid", "guru", "teman", "nama"],
            answerIndex: 1
        )

        XCTAssertEqual(q.id, 1)
        XCTAssertEqual(q.type, "Hanzi → Arti")
        XCTAssertEqual(q.stem, "Apa arti 老师 ?")
        XCTAssertEqual(q.options.count, 4)
        XCTAssertEqual(q.answerIndex, 1)
    }

    // MARK: - Chapter

    func testChapterQuestionCount() {
        let chapter = Chapter(
            id: 1,
            title: "Test Chapter",
            hanzi: "你",
            questions: [
                QuizQuestion(id: 1, type: "A", stem: "Q1", options: ["a", "b"], answerIndex: 0),
                QuizQuestion(id: 2, type: "B", stem: "Q2", options: ["a", "b"], answerIndex: 1),
                QuizQuestion(id: 3, type: "C", stem: "Q3", options: ["a", "b"], answerIndex: 0)
            ]
        )

        XCTAssertEqual(chapter.questionCount, 3)
    }

    func testChapterWithNoQuestions() {
        let chapter = Chapter(id: 1, title: "Empty", hanzi: "空", questions: [])
        XCTAssertEqual(chapter.questionCount, 0)
    }

    // MARK: - Chapter.sample (DEBUG fixture)

    func testChapterSampleIsValid() {
        let sample = Chapter.sample
        XCTAssertEqual(sample.id, 1)
        XCTAssertEqual(sample.title, "Perkenalan Diri")
        XCTAssertEqual(sample.hanzi, "你")
        XCTAssertEqual(sample.questionCount, 3)
        XCTAssertFalse(sample.questions.isEmpty)
    }

    // MARK: - Codable Round-Trip

    func testChapterCodableRoundTrip() throws {
        let original = Chapter.sample
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Chapter.self, from: data)

        XCTAssertEqual(decoded.id, original.id)
        XCTAssertEqual(decoded.title, original.title)
        XCTAssertEqual(decoded.hanzi, original.hanzi)
        XCTAssertEqual(decoded.questionCount, original.questionCount)
    }

    func testQuizQuestionCodableRoundTrip() throws {
        let original = QuizQuestion(
            id: 42,
            type: "Test",
            stem: "Stem?",
            options: ["A", "B", "C", "D"],
            answerIndex: 2
        )
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(QuizQuestion.self, from: data)

        XCTAssertEqual(decoded.id, original.id)
        XCTAssertEqual(decoded.answerIndex, original.answerIndex)
        XCTAssertEqual(decoded.options, original.options)
    }

    // MARK: - QuizData

    func testQuizDataDecodable() throws {
        let json = """
        {
            "chapters": [
                {
                    "id": 1,
                    "title": "Test",
                    "hanzi": "测",
                    "questions": []
                }
            ]
        }
        """.data(using: .utf8)!

        let quizData = try JSONDecoder().decode(QuizData.self, from: json)
        XCTAssertEqual(quizData.chapters.count, 1)
        XCTAssertEqual(quizData.chapters.first?.title, "Test")
    }

    // MARK: - Hashable

    func testChapterHashable() {
        let c1 = Chapter(id: 1, title: "A", hanzi: "一", questions: [])
        let c2 = Chapter(id: 1, title: "A", hanzi: "一", questions: [])
        XCTAssertEqual(c1, c2)
    }
}
