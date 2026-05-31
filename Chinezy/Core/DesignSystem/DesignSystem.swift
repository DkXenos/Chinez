import SwiftUI

struct DesignSystem {

    struct Colors {
        // ── Brand ──────────────────────────────────────────
        static let primary = Color(red: 179/255, green: 58/255, blue: 47/255)
        static let secondary = Color(red: 201/255, green: 165/255, blue: 45/255)

        // ── Surfaces ───────────────────────────────────────
        static let background = Color(red: 250/255, green: 246/255, blue: 234/255)
        static let secondaryBackground = Color(red: 250/255, green: 244/255, blue: 220/255)
        static let surfaceWhite = Color.white
        static let cardBackground = Color(UIColor.tertiarySystemBackground)

        // ── Text ───────────────────────────────────────────
        static let textPrimary = Color.black
        static let textSecondary = Color(red: 114/255, green: 113/255, blue: 108/255)
        static let textDark = Color(red: 43/255, green: 43/255, blue: 43/255)

        // ── Semantic / Feedback ────────────────────────────
        /// Alias for `primary`; use in error / incorrect contexts.
        static let error = primary
        /// Alias for `secondary`; gold accent.
        static let gold = secondary
        static let success = Color(red: 30/255, green: 140/255, blue: 95/255)
        static let goldLight = Color(red: 240/255, green: 216/255, blue: 122/255)

        // ── Borders / Accents ──────────────────────────────
        static let cardBorder = Color(red: 212/255, green: 175/255, blue: 55/255).opacity(0.5)
        /// Deeper red used in badges and secondary text accents.
        static let primaryDark = Color(red: 126/255, green: 40/255, blue: 32/255)
    }

    struct Typography {
        static let largeTitle = Font.system(.largeTitle, design: .rounded).weight(.bold)
        static let title = Font.system(.title, design: .rounded).weight(.semibold)
        static let title2 = Font.system(.title2, design: .rounded).weight(.bold)
        static let title3 = Font.system(.title3, design: .rounded).weight(.semibold)
        static let headline = Font.system(.headline, design: .rounded).weight(.medium)
        static let subheadline = Font.system(.subheadline, design: .rounded)
        static let subheadlineBold = Font.system(.subheadline, design: .rounded).weight(.bold)
        static let body = Font.system(.body, design: .rounded)
        static let caption = Font.system(.caption, design: .rounded)
    }

    struct Dimensions {
        static let cornerRadius: CGFloat = 16
        static let cornerRadiusSmall: CGFloat = 12
        static let cornerRadiusMedium: CGFloat = 14
        static let paddingStandard: CGFloat = 16
        static let paddingLarge: CGFloat = 24
        static let paddingSmall: CGFloat = 12
    }
}
