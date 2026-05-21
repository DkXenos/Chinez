import SwiftUI
import Combine

class FreeDrawCanvasViewModel: ObservableObject {
    @Published var recognizedCharacter: String = ""
    @Published var pinyin: String = ""
    
    func clearCanvas() {
        recognizedCharacter = ""
        pinyin = ""
    }
}
