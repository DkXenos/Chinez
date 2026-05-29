import SwiftUI

public struct CourseListView: View {
    @StateObject private var viewModel = CourseListViewModel()
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: DesignSystem.Dimensions.paddingStandard) {
                        ForEach(viewModel.courses) { course in
                            NavigationLink(destination: SubChapterListView(course: course)) {
                                CourseRowView(course: course)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(DesignSystem.Dimensions.paddingStandard)
                }
            }
            .navigationTitle("Belajar")
            .onAppear {
                viewModel.loadCourses()
            }
        }
    }
}

#Preview {
    CourseListView()
}
