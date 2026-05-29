import SwiftUI

public struct LearningBottomNavigationBar: View {
    let isShowingDialog: Bool
    let currentIndex: Int
    let totalCount: Int
    let onPrevious: () -> Void
    let onNextFlashcard: () -> Void
    let onOpenDialog: () -> Void
    let onBackToFlashcard: () -> Void

    public init(
        isShowingDialog: Bool,
        currentIndex: Int,
        totalCount: Int,
        onPrevious: @escaping () -> Void,
        onNextFlashcard: @escaping () -> Void,
        onOpenDialog: @escaping () -> Void,
        onBackToFlashcard: @escaping () -> Void
    ) {
        self.isShowingDialog = isShowingDialog
        self.currentIndex = currentIndex
        self.totalCount = totalCount
        self.onPrevious = onPrevious
        self.onNextFlashcard = onNextFlashcard
        self.onOpenDialog = onOpenDialog
        self.onBackToFlashcard = onBackToFlashcard
    }

    private var isLastCard: Bool {
        currentIndex >= totalCount - 1
    }

    public var body: some View {
        VStack(spacing: 12) {
            if isShowingDialog {
                Button(action: onBackToFlashcard) {
                    HStack {
                        Image(systemName: "arrow.left.circle.fill")
                        Text("Kembali ke Flashcard")
                    }
                    .font(DesignSystem.Typography.headline)
                    .foregroundColor(DesignSystem.Colors.primary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(DesignSystem.Colors.primary.opacity(0.1))
                    .cornerRadius(DesignSystem.Dimensions.cornerRadius)
                }
            } else {
                HStack(spacing: 16) {
                    if currentIndex > 0 {
                        Button(action: onPrevious) {
                            Image(systemName: "arrow.left")
                                .padding()
                                .background(DesignSystem.Colors.cardBackground)
                                .foregroundColor(DesignSystem.Colors.primary)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                        }
                    }

                    if isLastCard {
                        Button(action: onOpenDialog) {
                            HStack {
                                Text("Lihat Dialog")
                                Image(systemName: "arrow.right.circle.fill")
                            }
                            .font(DesignSystem.Typography.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(DesignSystem.Colors.secondaryBackground)
                            .cornerRadius(DesignSystem.Dimensions.cornerRadius)
                        }
                    } else {
                        Button(action: onNextFlashcard) {
                            Text("Flashcard Berikutnya")
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
