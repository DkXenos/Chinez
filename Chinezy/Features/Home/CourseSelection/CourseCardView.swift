import SwiftUI

struct CourseCardView: View {
    let course: Course
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            
            // Thumbnail matching QuizView's hanzi style
            ZStack {
                RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadiusMedium, style: .continuous)
                    .fill(DesignSystem.Colors.background)
                RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadiusMedium, style: .continuous)
                    .strokeBorder(DesignSystem.Colors.gold, lineWidth: 1.5)
                Text(course.icon) // we use course.icon to pass the chapter hanzi
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(DesignSystem.Colors.primary)
            }
            .frame(width: 80, height: 80)
            
            Text(course.title)
                .font(.headline)
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    CourseCardView(course: Course(
        title: "Bab 1: Perkenalan Diri",
        description: "",
        icon: "你",
        subChapters: [
            SubChapter(title: "1.1 Menyapa", dialogLines: []),
            SubChapter(title: "1.2 Berkenalan", dialogLines: [])
        ]
    ))
}
