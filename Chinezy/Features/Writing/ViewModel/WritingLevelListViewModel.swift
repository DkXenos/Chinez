import SwiftUI
import Foundation
import Combine

@MainActor
final class WritingLevelListViewModel: ObservableObject {

    @Published private(set) var levels: [WritingLevel] = []
    @Published private(set) var errorMessage: String?

    private let service: WritingDataServiceProtocol

    init(service: WritingDataServiceProtocol = WritingDataService()) {
        self.service = service
        load()
    }

    func load() {
        do {
            levels = try service.loadLevels()
            errorMessage = nil
        } catch {
            levels = []
            errorMessage = error.localizedDescription
        }
    }
}
