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
                                
                            case .course(let course):
                                SubChapterListView(course: course)
                            case .subChapter(let subChapter):
                                LearningView(subChapter: subChapter)
                                
                            case .courseList:
                                CourseListView()
                            case .tonePractice:
                                TonePracticeView()
                            case .dictionary:
                                EmptyView()
                            case .progress:
                                EmptyView()
                            }
                        }
                        .fullScreenCover(isPresented: $router.showFreeDrawCanvas) {
                                            FreeDrawCanvasView()
                                        }
                }
            }
        }
        .environmentObject(router)
    }
}

#Preview {
    ContentView()
}
