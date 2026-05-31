import SwiftUI

struct DesignSystem {
//    struct Colors {
//        static let primary = Color.blue
//        static let background = Color(UIColor.systemBackground)
//        static let secondaryBackground = Color(UIColor.secondarySystemBackground)
//        static let textPrimary = Color.primary
//        static let textSecondary = Color.secondary
//        static let cardBackground = Color(UIColor.tertiarySystemBackground)
//    }
    
    struct Colors {
        static let primary = Color(red: 179/255, green: 58/255, blue: 47/255)
        static let secondary = Color(red: 201/255, green: 165/255, blue: 45/255)
        static let background = Color(red: 250/255, green: 246/255, blue: 234/255)
        static let secondaryBackground = Color(red: 250/255, green: 244/255, blue: 220/255)
        static let textPrimary = Color.black
        static let textSecondary = Color(red: 114/255, green: 113/255, blue: 108/255)
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
