//
//  WritingDataService.swift
//  Chinez
//

import Foundation

protocol WritingDataServiceProtocol {
    func loadLevels() throws -> [WritingLevel]
}

struct WritingDataService: WritingDataServiceProtocol {

    enum DataError: LocalizedError {
        case fileNotFound
        case decodingFailed(Error)

        var errorDescription: String? {
            switch self {
            case .fileNotFound:
                return "File WritingExercise.json tidak ditemukan di bundle aplikasi."
            case .decodingFailed(let error):
                return "Gagal membaca WritingExercise.json: \(error.localizedDescription)"
            }
        }
    }

    private let resourceName: String

    init(resourceName: String = "WritingExercise") {
        self.resourceName = resourceName
    }

    func loadLevels() throws -> [WritingLevel] {
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: "json") else {
            throw DataError.fileNotFound
        }
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(WritingExerciseData.self, from: data)
            return decoded.levels.sorted { $0.id < $1.id }
        } catch let error as DataError {
            throw error
        } catch {
            throw DataError.decodingFailed(error)
        }
    }
}
