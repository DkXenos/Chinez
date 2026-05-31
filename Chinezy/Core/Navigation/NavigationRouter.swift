import SwiftUI
import Combine

enum AppState {
    case unauthenticated
    case home
}

enum AppRoute: Hashable {
    // Used
    case course(Course)
    case subChapter(SubChapter)
    
    case courseList
    case tonePractice
    case dictionary
    case progress
}

class NavigationRouter: ObservableObject {
    
    enum Tab: Hashable {
        case home
        case tonePractice
        case writing
    }
    
    @Published var currentState: AppState = .unauthenticated
    @Published var selectedTab: Tab = .home
    @Published var navigationPath = NavigationPath()
    @Published var selectedTheme: Theme?
    @Published var selectedPart: Part?
    @Published var showExercise: Bool = false
    @Published var showWritingQuiz: Bool = false
    
    func navigateToHome() {
        currentState = .home
    }
    
    func navigateToCourse(course: Course) {
        navigationPath.append(AppRoute.course(course))
    }
    
    func navigateToSubchapter(subChapter: SubChapter) {
        navigationPath.append(AppRoute.subChapter(subChapter))
    }
    
    func startExercise(part: Part) {
        selectedPart = part
        showExercise = true
    }
    
    func openWritingQuiz() {
        showWritingQuiz = true
    }
}
