import SwiftUI

public struct PlaceholderView: View {
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
    PlaceholderView(title: "Quiz section")
}
