//
//  VocabModels.swift
//  Chinez (watchOS)
//
//  Lapisan MODEL (MVVM).
//  Struktur data kosakata yang dimuat dari `vocab.json`.
//  Hanya berisi kata SATU KARAKTER (单字) dari Bab 1–15.
//

import Foundation

/// Root object yang dipetakan dari `vocab.json`.
struct VocabData: Codable {
    let vocab: [Vocab]
}

/// Satu kosakata: hanzi, pinyin, arti (+ asal bab sebagai konteks).
struct Vocab: Codable, Identifiable, Hashable {
    let id: Int
    let chapter: Int
    let hanzi: String
    let pinyin: String
    let arti: String
}
