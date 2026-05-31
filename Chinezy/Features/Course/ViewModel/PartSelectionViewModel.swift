import SwiftUI
import Combine

class PartSelectionViewModel: ObservableObject {
    @Published var parts: [Part] = [
        Part(name: "Part 1", characterCount: 15, progress: 1.0),
        Part(name: "Part 2", characterCount: 12, progress: 0.5),
        Part(name: "Part 3", characterCount: 18, progress: 0.0)
    ]
}
