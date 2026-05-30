//
//  QuizDataService.swift
//  Chinez
//
//

import Foundation

protocol QuizDataServiceProtocol {
    func loadChapters() throws -> [Chapter]
}

struct QuizDataService: QuizDataServiceProtocol {

    enum DataError: LocalizedError {
        case fileNotFound
        case decodingFailed(Error)

        var errorDescription: String? {
            switch self {
            case .fileNotFound:
                return "File quiz.json tidak ditemukan di bundle aplikasi."
            case .decodingFailed(let error):
                return "Gagal membaca quiz.json: \(error.localizedDescription)"
            }
        }
    }

    private let resourceName: String

    init(resourceName: String = "quiz") {
        self.resourceName = resourceName
    }

    func loadChapters() throws -> [Chapter] {
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: "json") else {
            throw DataError.fileNotFound
        }
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(QuizData.self, from: data)
            // Urutkan berdasarkan id bab agar tampil 1..15 secara konsisten.
            return decoded.chapters.sorted { $0.id < $1.id }
        } catch let error as DataError {
            throw error
        } catch {
            throw DataError.decodingFailed(error)
        }
    }
}
