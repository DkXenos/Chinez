import SwiftUI

public struct ChapterPlaceholderView: View {
    let title: String

    public var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Text(title)
                .font(DesignSystem.Typography.headline)
                .foregroundColor(DesignSystem.Colors.textPrimary)
            Spacer()
        }
    }
}

#Preview {
    ChapterPlaceholderView(title: "Quiz section")
}
