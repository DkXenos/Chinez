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
                if isIPad {
                    IPadSidebarView()
                } else {
                    IPhoneTabView()
                }
            }
        }
        .environmentObject(router)
    }
}

// MARK: - iPad Sidebar Layout
struct IPadSidebarView: View {
    @EnvironmentObject var router: NavigationRouter
    
    // We optionally bind the NavigationSplitView's column visibility
    @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn
    
    private var tabSelection: Binding<NavigationRouter.Tab?> {
        Binding(
            get: { router.selectedTab },
            set: { newValue in
                if let newValue = newValue {
                    router.selectedTab = newValue
                }
            }
        )
    }
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: tabSelection) {
                NavigationLink(value: NavigationRouter.Tab.materials) {
                    Label("Materials", systemImage: "character.book.closed.fill")
                }
                NavigationLink(value: NavigationRouter.Tab.quiz) {
                    Label("Quiz", systemImage: "questionmark.circle.fill")
                }
                NavigationLink(value: NavigationRouter.Tab.writing) {
                    Label("Writing", systemImage: "pencil.tip.crop.circle")
                }
                NavigationLink(value: NavigationRouter.Tab.profile) {
                    Label("Profile", systemImage: "person.fill")
                }
            }
            .navigationTitle("Menu")
        } detail: {
            switch router.selectedTab {
            case .materials:
                NavigationStack(path: $router.navigationPath) {
                    CourseListView()
                        .navigationDestination(for: AppRoute.self) { route in
                            appRouteDestination(route)
                        }
                }
            case .quiz:
                NavigationStack {
                    ChapterListView()
                }
            case .writing:
                NavigationStack {
                    WritingLevelListView()
                }
            case .profile:
                NavigationStack {
                    ProfileView()
                }
            default:
                EmptyView()
            }
        }
    }
    
    @ViewBuilder
    private func appRouteDestination(_ route: AppRoute) -> some View {
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

// MARK: - iPhone Tab Layout
struct IPhoneTabView: View {
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        TabView(selection: $router.selectedTab) {
            
            // ── Materials ──────────────────────────────
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
            
            // ── Quiz ────────────────────────────────────
            NavigationStack {
                ChapterListView()
            }
            .tabItem {
                Label("Quiz", systemImage: "questionmark.circle.fill")
            }
            .tag(NavigationRouter.Tab.quiz)
            
            // ── Tones ───────────────────────────────────
            NavigationStack {
                TonePracticeView()
            }
            .tabItem {
                Label("Tones", systemImage: "waveform")
            }
            .tag(NavigationRouter.Tab.tonePractice)
            
            // ── Profile ─────────────────────────────────
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

#Preview {
    ContentView()
}
