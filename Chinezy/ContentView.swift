import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var router = NavigationRouter()

    /// `true` only when running on iPad.
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    var body: some View {
        Group {
            switch router.currentState {
            case .unauthenticated:
                LandingView()

            case .home:
                TabView(selection: $router.selectedTab) {

                    // ── Home (universal) ────────────────────────
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
                            .fullScreenCover(isPresented: $router.showWritingQuiz) {
                                QuizView()
                            }
                    }
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                    .tag(NavigationRouter.Tab.home)

                    // ── Tone Practice (universal) ───────────────
                    NavigationStack {
                        TonePracticeView()
                    }
                    .tabItem {
                        Label("Tones", systemImage: "waveform")
                    }
                    .tag(NavigationRouter.Tab.tonePractice)

                    // ── Writing Practice (iPad only) ────────────
                    if isIPad {
                        NavigationStack {
                            QuizView()
                        }
                        .tabItem {
                            Label("Writing", systemImage: "pencil.tip.crop.circle")
                        }
                        .tag(NavigationRouter.Tab.writing)
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
