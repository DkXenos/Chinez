import Foundation

public struct Course: Identifiable, Codable {
    public let id: UUID
    public var title: String
    public var description: String
    public var subChapters: [SubChapter]

    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        subChapters: [SubChapter] = []
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.subChapters = subChapters
    }
}
