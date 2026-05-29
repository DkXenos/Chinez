import SwiftUI

public struct SubChapterRowView: View {
    let subChapter: SubChapter

    public init(subChapter: SubChapter) {
        self.subChapter = subChapter
    }

    public var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(DesignSystem.Colors.primary.opacity(0.1))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: "book.fill")
                        .foregroundColor(DesignSystem.Colors.primary)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(subChapter.title)
                    .font(DesignSystem.Typography.headline)
                    .foregroundColor(DesignSystem.Colors.textPrimary)

                Text("\(subChapter.flashcards.count) Kosakata")
                    .font(DesignSystem.Typography.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .font(.system(size: 14, weight: .bold))
        }
        .padding(DesignSystem.Dimensions.paddingStandard)
        .background(DesignSystem.Colors.cardBackground)
        .cornerRadius(DesignSystem.Dimensions.cornerRadius)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}


struct SubChapterRowView_Previews: PreviewProvider {
    static var previews: some View {
        SubChapterRowView(
            subChapter: SubChapter(
                title: "1.1 Menyapa",
                flashcards: [],
                dialogText: "A: 你好！\nB: 你好！"
            )
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
