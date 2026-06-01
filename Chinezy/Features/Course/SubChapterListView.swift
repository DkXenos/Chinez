import SwiftUI

struct SubChapterListView: View {
    let course: Course
    @State private var selectedTab: ChapterTabOption = .material

    public var body: some View {
        ZStack {
            DesignSystem.Colors.background.ignoresSafeArea()

            VStack(spacing: 0) {
                materialContent
            }
        }
        .navigationTitle(course.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var materialContent: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Dimensions.paddingStandard) {
                ForEach(course.subChapters) { subChapter in
                    NavigationLink(destination: LearningView(subChapter: subChapter)) {
                        SubChapterRowView(subChapter: subChapter)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(DesignSystem.Dimensions.paddingStandard)
        }
    }
}


struct SubChapterListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SubChapterListView(
                course: Course(
                    title: "Bab 1: Perkenalan Diri",
                    description: "Belajar menyapa, berkenalan, dan menanyakan umur atau profesi.",
                    icon: "book.fill",
                    subChapters: [
                        SubChapter(title: "1.1 Menyapa", dialogLines: []),
                        SubChapter(title: "1.2 Berkenalan", dialogLines: [])
                    ]
                )
            )
        }
    }
}
