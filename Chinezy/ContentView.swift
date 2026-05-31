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

                    // ── Materials (universal) ───────────────────
                    NavigationStack(path: $router.navigationPath) {
                        CourseListView()
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
                    }
                    .tabItem {
                        Label("Materials", systemImage: "character.book.closed.fill")
                    }
                    .tag(NavigationRouter.Tab.materials)

                    // ── Quiz (universal) ─────────────────────────
                    NavigationStack {
                        ChapterListView()
                    }
                    .tabItem {
                        Label("Quiz", systemImage: "questionmark.circle.fill")
                    }
                    .tag(NavigationRouter.Tab.quiz)

                    // ── Tones (universal) ────────────────────────
                    NavigationStack {
                        TonePracticeView()
                    }
                    .tabItem {
                        Label("Tones", systemImage: "waveform")
                    }
                    .tag(NavigationRouter.Tab.tonePractice)

                    // ── Writing (iPad only) ──────────────────────
                    if isIPad {
                        NavigationStack {
                            WritingLevelListView()
                        }
                        .tabItem {
                            Label("Writing", systemImage: "pencil.tip.crop.circle")
                        }
                        .tag(NavigationRouter.Tab.writing)
                    }

                    // ── Profile (universal) ──────────────────────
                    NavigationStack {
                        ProfileView()
                    }
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
                    .tag(NavigationRouter.Tab.profile)
                }
                .tint(DesignSystem.Colors.primary)
            }
        }
        .environmentObject(router)
    }
}

#Preview {
    ContentView()
}
