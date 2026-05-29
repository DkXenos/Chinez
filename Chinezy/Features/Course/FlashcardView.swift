import SwiftUI

public struct FlashcardView: View {
    let flashcard: Flashcard
    let isFlipped: Bool

    public init(flashcard: Flashcard, isFlipped: Bool) {
        self.flashcard = flashcard
        self.isFlipped = isFlipped
    }

    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadius)
                .fill(DesignSystem.Colors.cardBackground)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)

            if isFlipped {
                backFace
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            } else {
                frontFace
            }
        }
        .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .animation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0), value: isFlipped)
    }

    private var frontFace: some View {
        VStack(spacing: 24) {
            if let imageRef = flashcard.imageRef {
                Image(systemName: imageRef)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .foregroundColor(DesignSystem.Colors.primary)
            }
            Text(flashcard.hanzi)
                .font(.system(size: 80, weight: .bold, design: .rounded))
                .foregroundColor(DesignSystem.Colors.textPrimary)
        }
    }

    private var backFace: some View {
        VStack(spacing: 16) {
            Text(flashcard.pinyin)
                .font(DesignSystem.Typography.title)
                .foregroundColor(DesignSystem.Colors.primary)

            Text(flashcard.indonesianTranslation)
                .font(DesignSystem.Typography.headline)
                .foregroundColor(DesignSystem.Colors.textPrimary)
        }
    }
}


struct FlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardView(
            flashcard: Flashcard(hanzi: "你好", pinyin: "nǐ hǎo", indonesianTranslation: "halo", imageRef: "hand.wave.fill", audioRef: ""),
            isFlipped: false
        )
        .frame(height: 400)
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
