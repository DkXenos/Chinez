import SwiftUI
import Combine

enum AppState {
    case unauthenticated
    case home
}

enum AppRoute: Hashable {
    case theme(Theme)
    case part(Part)
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
    
    func navigateToCourse(theme: Theme) {
        navigationPath.append(AppRoute.theme(theme))
    }
    
    func navigateToPart(part: Part) {
        navigationPath.append(AppRoute.part(part))
    }
    
    func startExercise(part: Part) {
        selectedPart = part
        showExercise = true
    }
    
    func openFreeDrawCanvas() {
        showFreeDrawCanvas = true
    }
}
