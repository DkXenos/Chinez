import SwiftUI

struct DesignSystem {
    struct Colors {
        static let primary = Color.blue
        static let background = Color(UIColor.systemBackground)
        static let secondaryBackground = Color(UIColor.secondarySystemBackground)
        static let textPrimary = Color.primary
        static let textSecondary = Color.secondary
        static let cardBackground = Color(UIColor.tertiarySystemBackground)
    }
    
    struct Typography {
        static let largeTitle = Font.system(.largeTitle, design: .rounded).weight(.bold)
        static let title = Font.system(.title, design: .rounded).weight(.semibold)
        static let headline = Font.system(.headline, design: .rounded).weight(.medium)
        static let body = Font.system(.body, design: .rounded)
        static let caption = Font.system(.caption, design: .rounded)
    }
    
    struct Dimensions {
        static let cornerRadius: CGFloat = 16
        static let paddingStandard: CGFloat = 16
        static let paddingLarge: CGFloat = 24
    }
}
