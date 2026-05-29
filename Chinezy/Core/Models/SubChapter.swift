import Foundation

public struct SubChapter: Identifiable, Codable {
    public let id: UUID
    public var title: String
    public var flashcards: [Flashcard]
    public var dialogText: String
    public var dialogAudioRef: String

    public init(
        id: UUID = UUID(),
        title: String,
        flashcards: [Flashcard] = [],
        dialogText: String,
        dialogAudioRef: String = ""
    ) {
        self.id = id
        self.title = title
        self.flashcards = flashcards
        self.dialogText = dialogText
        self.dialogAudioRef = dialogAudioRef
    }
}
