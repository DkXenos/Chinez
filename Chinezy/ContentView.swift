import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var router = NavigationRouter()

    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    var body: some View {
        Group {
            if isIPad {
                IPadSidebarView()
            } else {
                IPhoneTabView()
            }
        }
        .environmentObject(router)
    }
}

struct IPadSidebarView: View {
    @EnvironmentObject var router: NavigationRouter
    
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

struct IPhoneTabView: View {
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        TabView(selection: $router.selectedTab) {
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
            
            NavigationStack {
                ChapterListView()
            }
            .tabItem {
                Label("Quiz", systemImage: "questionmark.circle.fill")
            }
            .tag(NavigationRouter.Tab.quiz)
            
            NavigationStack {
                ToneListView()
            }
            .tabItem {
                Label("Tones", systemImage: "waveform")
            }
            .tag(NavigationRouter.Tab.tonePractice)
        }
        .tint(DesignSystem.Colors.primary)
    }
}

#Preview {
    ContentView()
}
