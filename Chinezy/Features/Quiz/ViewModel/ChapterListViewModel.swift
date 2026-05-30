//
//  ChapterListViewModel.swift
//  Chinez
//
//

import Foundation
import Combine

@MainActor
final class ChapterListViewModel: ObservableObject {

    @Published private(set) var chapters: [Chapter] = []
    @Published private(set) var errorMessage: String?

    private let service: QuizDataServiceProtocol

    init(service: QuizDataServiceProtocol = QuizDataService()) {
        self.service = service
        load()
    }

    func load() {
        do {
            chapters = try service.loadChapters()
            errorMessage = nil
        } catch {
            chapters = []
            errorMessage = error.localizedDescription
        }
    }
}
