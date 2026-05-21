import SwiftUI

struct ExerciseContainerView: View {
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var viewModel = ExerciseViewModel()
    let part: Part
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isQuizComplete {
                    VStack(spacing: DesignSystem.Dimensions.paddingLarge) {
                        Text("Level Complete!")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                        
                        Text("Total Mistakes: \(viewModel.mistakeCount)")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                        
                        PrimaryButton(title: "Return to Course", systemImage: "checkmark.circle.fill") {
                            router.showExercise = false
                        }
                        .padding(.horizontal, DesignSystem.Dimensions.paddingLarge)
                        .padding(.top, DesignSystem.Dimensions.paddingLarge)
                    }
                } else {
                    VStack(spacing: DesignSystem.Dimensions.paddingStandard) {
                        Text("\(viewModel.currentIndex + 1) / \(viewModel.charactersToLearn.count)")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                            .padding(.top, DesignSystem.Dimensions.paddingLarge)
                        
                        Text(viewModel.currentCharacter)
                            .font(.system(size: 120, weight: .bold))
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                            .padding(.top, DesignSystem.Dimensions.paddingStandard)
                        
                        Spacer()
                        
                        ZStack {
                            CanvasPlaceholder()
                                .padding(DesignSystem.Dimensions.paddingLarge)
                            
                            StrokeCanvasView(
                                character: viewModel.currentCharacter,
                                onCharacterFinished: {
                                    viewModel.characterCompleted()
                                },
                                onMistake: {
                                    viewModel.registerMistake()
                                }
                            )
                            .id(viewModel.currentCharacter)
                            .padding(DesignSystem.Dimensions.paddingLarge)
                        }
                        
                        Spacer()
                    }
                }
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
