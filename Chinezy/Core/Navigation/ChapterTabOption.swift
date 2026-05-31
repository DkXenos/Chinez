import SwiftUI

public enum ChapterTabOption: String, CaseIterable, Identifiable {
    case material = "Material"
    case quiz = "Quiz"
    case writing = "Writing"

    public var id: String { rawValue }
}
