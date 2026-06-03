import Foundation

struct SubChapter: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    let title: String
    var flashcards: [Flashcard] = []
    let dialogLines: [DialogLine]
    var dialogAudioRef: String = ""
}
