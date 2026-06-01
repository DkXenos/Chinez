import SwiftUI

struct LearningBottomNavigationBar: View {
    let isShowingDialog: Bool
    let currentIndex: Int
    let totalCount: Int
    let onPrevious: () -> Void
    let onNextFlashcard: () -> Void
    let onOpenDialog: () -> Void
    let onBackToFlashcard: () -> Void

    private var isFirstCard: Bool {
        currentIndex == 0
    }
    
    private var isLastCard: Bool {
        currentIndex >= totalCount - 1
    }

    public var body: some View {
        VStack(spacing: 12) {
            if isShowingDialog {
                
                // DIALOG BUTTON
                Button(action: onBackToFlashcard) {
                    HStack {
                        Image(systemName: "arrow.left.circle")
                        Text("Flashcard")
                    }
                    .font(DesignSystem.Typography.headline)
                    .foregroundColor(DesignSystem.Colors.primary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(DesignSystem.Colors.primary.opacity(0.1))
                    .cornerRadius(DesignSystem.Dimensions.cornerRadius)
                }
            } else {
                
                // FLASHCARD BUTTON
                HStack(spacing: 16) {
                    
                    // Back Button
                    if !isFirstCard {
                        Button(action: onPrevious) {
                            HStack {
                                Text("Back")
                            }
                                .foregroundColor(DesignSystem.Colors.primary)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(DesignSystem.Colors.cardBackground)
                                .cornerRadius(DesignSystem.Dimensions.cornerRadius)
                                .shadow(radius: 2)
                        }
                    }

                    // Next Button
                    if isLastCard {
                        Button(action: onOpenDialog) {
                            HStack {
                                Text("Dialog")
                                Image(systemName: "arrow.right.circle")
                            }
                            .font(DesignSystem.Typography.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(DesignSystem.Colors.primary)
                            .cornerRadius(DesignSystem.Dimensions.cornerRadius)
                        }
                    } else {
                        Button(action: onNextFlashcard) {
                            Text("Next")
                                .font(DesignSystem.Typography.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(DesignSystem.Colors.primary)
                                .cornerRadius(DesignSystem.Dimensions.cornerRadius)
                        }
                    }
                }
            }
        }
        .padding(.top, 8)
    }
}

#Preview {
    LearningBottomNavigationBar(isShowingDialog: true, currentIndex: 3, totalCount: 4, onPrevious: {}, onNextFlashcard: {}, onOpenDialog: {}, onBackToFlashcard: {})
}
