//
//  DailyVocabularyViewModel.swift
//  Chinez (watchOS)
//
//  VIEWMODEL (MVVM) untuk fitur Daily Vocabulary.
//  - Saat dibuka: menampilkan satu kata "hari ini" (dipilih berdasarkan tanggal,
//    jadi konsisten sepanjang hari).
//  - shuffle(): mengganti ke kata acak yang berbeda dari yang sedang tampil.
//

import Foundation
import Combine

@MainActor
final class DailyVocabularyViewModel: ObservableObject {

    @Published private(set) var current: Vocab?
    @Published private(set) var errorMessage: String?

    private var allVocab: [Vocab] = []
    private let service: VocabDataServiceProtocol

    init(service: VocabDataServiceProtocol = VocabDataService()) {
        self.service = service
        load()
    }

    func load() {
        do {
            let items = try service.loadVocab()
            guard !items.isEmpty else {
                errorMessage = "Daftar kosakata kosong."
                current = nil
                return
            }
            allVocab = items
            current = todaysVocab()
            errorMessage = nil
        } catch {
            allVocab = []
            current = nil
            errorMessage = error.localizedDescription
        }
    }

    private func todaysVocab() -> Vocab? {
        guard !allVocab.isEmpty else { return nil }
        let day = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = (day - 1) % allVocab.count
        return allVocab[index]
    }

    func shuffle() {
        guard allVocab.count > 1 else {
            current = allVocab.first
            return
        }
        var next = current
        while next == current {
            next = allVocab.randomElement()
        }
        current = next
    }
}
