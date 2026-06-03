import Foundation

struct Course: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    let title: String
    let description: String
    let icon: String
    let subChapters: [SubChapter]
}
