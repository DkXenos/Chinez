import SwiftUI

public struct CourseRowView: View {
    let course: Course

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(course.title)
                .font(DesignSystem.Typography.headline)
                .foregroundColor(DesignSystem.Colors.textPrimary)

            Text(course.description)
                .font(DesignSystem.Typography.body)
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .lineLimit(2)

            HStack {
                Spacer()
                Text("\(course.subChapters.count) Subbab")
                    .font(DesignSystem.Typography.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(DesignSystem.Colors.primary.opacity(0.1))
                    .foregroundColor(DesignSystem.Colors.primary)
                    .clipShape(Capsule())
            }
            .padding(.top, 4)
        }
        .padding(DesignSystem.Dimensions.paddingLarge)
        .background(DesignSystem.Colors.cardBackground)
        .cornerRadius(DesignSystem.Dimensions.cornerRadius)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    CourseRowView(course: Course(
        title: "Bab 1: Perkenalan Diri",
        description: "Belajar menyapa, berkenalan, dan menanyakan umur atau profesi.",
        icon: "book.fill",
        subChapters: [
            SubChapter(title: "1.1 Menyapa", dialogText: ""),
            SubChapter(title: "1.2 Berkenalan", dialogText: "")
        ]
    ))
}
