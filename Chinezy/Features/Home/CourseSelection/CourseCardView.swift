import SwiftUI

struct CourseCardView: View {
    let course: Course
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack {
                Image(systemName: course.icon)
                    .font(.title)
                    .foregroundColor(DesignSystem.Colors.primary)
                    .frame(width: 100, height: 100)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(DesignSystem.Colors.primary.opacity(0.1))
                    )
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(course.title)
                    .font(.headline)
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .lineLimit(3)
                
                Text(course.description)
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .lineLimit(3)
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .frame(height: 260)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    CourseCardView(course: Course(
        title: "Bab 1: Perkenalan Diri",
        description: "Belajar menyapa, berkenalan, dan menanyakan umur atau profesi.",
        icon: "book.fill",
        subChapters: [
            SubChapter(title: "1.1 Menyapa", dialogLines: []),
            SubChapter(title: "1.2 Berkenalan", dialogLines: [])
        ]
    ))
}
