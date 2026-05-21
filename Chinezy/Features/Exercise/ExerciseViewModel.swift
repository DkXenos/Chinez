import SwiftUI
import Combine

class ExerciseViewModel: ObservableObject {
    @Published var selectedMode: ExerciseMode = .stroke
    @Published var characters: [String] = ["我", "是", "中", "国", "人"]
    @Published var selectedCharacter: String? = "我"
}
