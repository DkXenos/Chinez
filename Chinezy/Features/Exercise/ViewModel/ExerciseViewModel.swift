import SwiftUI
import Foundation
import Combine

class ExerciseViewModel: ObservableObject {
    @Published var charactersToLearn: [String]
    @Published var currentIndex: Int = 0
    @Published var mistakeCount: Int = 0
    @Published var isQuizComplete: Bool = false
    
    // Hold a reference to any async unstructured work (e.g., Firebase saves)
    var updateTask: Task<Void, Never>?
    
    deinit {
        updateTask?.cancel()
    }
    
    init(characters: [String] = ["我", "是", "中", "国", "人"]) {
        self.charactersToLearn = characters
    }
    
    var currentCharacter: String {
        guard currentIndex < charactersToLearn.count else { return "" }
        return charactersToLearn[currentIndex]
    }
    
    func characterCompleted() {
        currentIndex += 1
        if currentIndex >= charactersToLearn.count {
            isQuizComplete = true
            // If saving progress to Firebase is added here in the future:
            // updateTask = Task { ... }
        }
    }
    
    func registerMistake() {
        mistakeCount += 1
    }
}
