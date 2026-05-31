//
//  VocabDataService.swift
//  Chinez (watchOS)
//
//  Lapisan SERVICE.
//  Memuat kosakata dari `vocab.json` di bundle. Protocol-based agar mudah
//  di-mock saat testing atau diganti sumbernya kelak.
//

import Foundation

protocol VocabDataServiceProtocol {
    func loadVocab() throws -> [Vocab]
}

struct VocabDataService: VocabDataServiceProtocol {

    enum DataError: LocalizedError {
        case fileNotFound
        case decodingFailed(Error)

        var errorDescription: String? {
            switch self {
            case .fileNotFound:
                return "File vocab.json tidak ditemukan di bundle."
            case .decodingFailed(let error):
                return "Gagal membaca vocab.json: \(error.localizedDescription)"
            }
        }
    }

    private let resourceName: String

    init(resourceName: String = "vocab") {
        self.resourceName = resourceName
    }

    func loadVocab() throws -> [Vocab] {
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: "json") else {
            throw DataError.fileNotFound
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(VocabData.self, from: data).vocab
        } catch let error as DataError {
            throw error
        } catch {
            throw DataError.decodingFailed(error)
        }
    }
}
