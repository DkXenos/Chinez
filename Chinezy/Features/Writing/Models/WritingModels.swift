//
//  WritingModels.swift
//  Chinez
//

import Foundation

/// Top-level wrapper matching the WritingExercise.json structure.
struct WritingExerciseData: Codable {
    let levels: [WritingLevel]
}

/// A single writing exercise level containing a list of Hanzi characters.
struct WritingLevel: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let characters: [String]

    var characterCount: Int { characters.count }
}

#if DEBUG
extension WritingLevel {
    static let sample = WritingLevel(
        id: 1,
        title: "Angka Dasar",
        characters: ["一", "二", "三", "四", "五"]
    )
}
#endif
