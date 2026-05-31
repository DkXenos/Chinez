import Foundation

struct Flashcard: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    let hanzi: String
    let pinyin: String
    let indonesianTranslation: String
    let imageRef: String?
    let audioRef: String?
}
