import SwiftUI
import Combine

class ThemeSelectionViewModel: ObservableObject {
    @Published var themes: [Theme] = [
        Theme(name: "Airport", iconName: "airplane", isLocked: false),
        Theme(name: "Food", iconName: "fork.knife", isLocked: false),
        Theme(name: "School", iconName: "graduationcap", isLocked: true),
        Theme(name: "Travel", iconName: "map", isLocked: true)
    ]
    @Published var searchText: String = ""
}
