import Foundation

public struct Flashcard: Identifiable, Codable {
    public let id: UUID
    public var hanzi: String
    public var pinyin: String
    public var indonesianTranslation: String
    public var imageRef: String?
    public var audioRef: String?

    public init(
        id: UUID = UUID(),
        hanzi: String,
        pinyin: String,
        indonesianTranslation: String,
        imageRef: String? = nil,
        audioRef: String? = nil
    ) {
        self.id = id
        self.hanzi = hanzi
        self.pinyin = pinyin
        self.indonesianTranslation = indonesianTranslation
        self.imageRef = imageRef
        self.audioRef = audioRef
    }
}
