import SwiftUI

public struct CourseListView: View {
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var viewModel = CourseListViewModel()
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    public var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: DesignSystem.Dimensions.paddingStandard) {
                ForEach(viewModel.filteredCourses) { course in
                    Button(action: {
                        router.navigateToCourse(course: course)
                    }) {
                        CourseCardView(course: course)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(DesignSystem.Dimensions.paddingStandard)
        }
        .navigationTitle("Belajar")
        .searchable(text: $viewModel.searchText, prompt: "Cari materi belajar...")
        .background(DesignSystem.Colors.background.ignoresSafeArea())
        .onAppear {
            viewModel.loadCourses()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    router.openFreeDrawCanvas()
                }) {
                    Image(systemName: "pencil.tip.crop.circle")
                        .foregroundColor(DesignSystem.Colors.primary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CourseListView()
            .environmentObject(NavigationRouter())
    }
}
