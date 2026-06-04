
import Foundation


struct QuizData: Codable {
    let chapters: [Chapter]
}

struct Chapter: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let hanzi: String
    let questions: [QuizQuestion]
    var questionCount: Int { questions.count }
}

struct QuizQuestion: Codable, Identifiable, Hashable {
    let id: Int
    let type: String
    let stem: String
    let options: [String]
    let answerIndex: Int
}


#if DEBUG
extension Chapter {
    static let sample = Chapter(
        id: 1,
        title: "Perkenalan Diri",
        hanzi: "你",
        questions: [
            QuizQuestion(id: 1, type: "Hanzi → Arti",
                         stem: "Apa arti 老师 ?",
                         options: ["murid", "guru", "teman", "nama"], answerIndex: 1),
            QuizQuestion(id: 2, type: "Pinyin → Hanzi",
                         stem: "Hanzi untuk «péngyou» (teman) adalah …",
                         options: ["老师", "学生", "朋友", "名字"], answerIndex: 2),
            QuizQuestion(id: 3, type: "Hanzi → Pinyin",
                         stem: "Pinyin yang benar untuk 高兴 adalah …",
                         options: ["gāoxīng", "gāoxìng", "gàoxìng", "gāoxíng"], answerIndex: 1)
        ]
    )
}
#endif
