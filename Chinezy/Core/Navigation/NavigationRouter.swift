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
    case freeDraw
    case dictionary
    case progress
}

class NavigationRouter: ObservableObject {
    @Published var currentState: AppState = .unauthenticated
    @Published var navigationPath = NavigationPath()
    @Published var selectedTheme: Theme?
    @Published var selectedPart: Part?
    @Published var showExercise: Bool = false
    @Published var showFreeDrawCanvas: Bool = false
    
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
    
    func openFreeDrawCanvas() {
        showFreeDrawCanvas = true
    }
}
