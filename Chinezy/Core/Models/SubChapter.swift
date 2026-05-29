import Foundation

struct SubChapter: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    let title: String
    var flashcards: [Flashcard] = []
    var dialogText: String = ""
    var dialogAudioRef: String = ""
}
