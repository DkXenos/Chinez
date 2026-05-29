import SwiftUI

public struct LearningFlashcardContent: View {
    let flashcard: Flashcard
    let isFlipped: Bool
    let currentIndex: Int
    let totalCount: Int
    let onTap: () -> Void

    public var body: some View {
        VStack(spacing: 12) {
            FlashcardView(flashcard: flashcard, isFlipped: isFlipped)
                .frame(maxHeight: .infinity)
                .onTapGesture(perform: onTap)

            Text("\(currentIndex + 1) / \(totalCount) Kosakata")
                .font(DesignSystem.Typography.headline)
                .foregroundColor(DesignSystem.Colors.textSecondary)
        }
    }
}
