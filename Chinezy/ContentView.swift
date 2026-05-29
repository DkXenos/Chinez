import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var router = NavigationRouter()
    
    var body: some View {
        Group {
            switch router.currentState {
            case .unauthenticated:
                LandingView()
            case .home:
                NavigationStack(path: $router.navigationPath) {
                    HomeView()
                        .navigationDestination(for: AppRoute.self) { route in
                            switch route {
                            case .theme(let theme):
                                PartSelectionView(theme: theme)
                            case .course(let course):
                                CourseListView()
                            case .part(_):
                                EmptyView()
                            }
                        }
                }
                .fullScreenCover(isPresented: $router.showExercise) {
                    if let part = router.selectedPart {
                        ExerciseContainerView(part: part)
                    }
                }
                .fullScreenCover(isPresented: $router.showFreeDrawCanvas) {
                    FreeDrawCanvasView()
                }
            }
        }
        .environmentObject(router)
    }
}

#Preview {
    ContentView()
}
