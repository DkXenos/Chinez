import SwiftUI

struct ThemeSelectionView: View {
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var viewModel = ThemeSelectionViewModel()
    
    var filteredThemes: [Theme] {
        if viewModel.searchText.isEmpty {
            return viewModel.themes
        } else {
            return viewModel.themes.filter { $0.name.localizedCaseInsensitiveContains(viewModel.searchText) }
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: DesignSystem.Dimensions.paddingStandard) {
                ForEach(filteredThemes) { theme in
                    Button(action: {
                        if !theme.isLocked {
                            router.navigateToCourse(theme: theme)
                        }
                    }) {
                        ThemeCard(theme: theme)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(DesignSystem.Dimensions.paddingStandard)
        }
        .navigationTitle("Themes")
        .searchable(text: $viewModel.searchText, prompt: "Search themes")
        .background(DesignSystem.Colors.background.ignoresSafeArea())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    router.openFreeDrawCanvas()
                }) {
                    Image(systemName: "pencil.tip.crop.circle")
                        .foregroundColor(DesignSystem.Colors.primary)
                }
            }
        }
    }
}
