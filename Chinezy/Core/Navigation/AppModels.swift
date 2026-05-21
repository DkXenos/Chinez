import Foundation

struct Theme: Hashable, Identifiable {
    let id = UUID()
    let name: String
    let iconName: String
    let isLocked: Bool
}

struct Part: Hashable, Identifiable {
    let id = UUID()
    let name: String
    let characterCount: Int
    let progress: Double
}
