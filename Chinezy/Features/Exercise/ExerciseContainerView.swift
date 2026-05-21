import SwiftUI

struct ExerciseContainerView: View {
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var viewModel = ExerciseViewModel()
    let part: Part
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: DesignSystem.Dimensions.paddingStandard) {
                        ForEach(viewModel.characters, id: \.self) { char in
                            Button(action: {
                                viewModel.selectedCharacter = char
                            }) {
                                Text(char)
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(viewModel.selectedCharacter == char ? .white : DesignSystem.Colors.textPrimary)
                                    .frame(width: 80, height: 80)
                                    .background(viewModel.selectedCharacter == char ? DesignSystem.Colors.primary : DesignSystem.Colors.secondaryBackground)
                                    .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadius))
                            }
                        }
                    }
                    .padding(DesignSystem.Dimensions.paddingStandard)
                }
                
                Spacer()
                
                ZStack {
                    CanvasPlaceholder()
                        .padding(DesignSystem.Dimensions.paddingLarge)
                    
                    if let selectedChar = viewModel.selectedCharacter {
                        Text(selectedChar)
                            .font(.system(size: 200))
                            .foregroundColor(DesignSystem.Colors.textSecondary.opacity(0.15))
                        
                        StrokeCanvasView(character: selectedChar)
                            .id(selectedChar)
                            .padding(DesignSystem.Dimensions.paddingLarge)
                    }
                }
                
                Spacer()
                
                ExerciseNavBar(selectedMode: $viewModel.selectedMode)
                    .padding(.bottom, DesignSystem.Dimensions.paddingStandard)
            }
            .navigationTitle(part.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        router.showExercise = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                    }
                }
            }
            .background(DesignSystem.Colors.background.ignoresSafeArea())
        }
    }
}
