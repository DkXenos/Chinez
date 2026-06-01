import SwiftUI

struct FlashcardView: View {
    let flashcard: Flashcard
    let isFlipped: Bool
    let onFlip: () -> Void
    let onPlayAudio: () -> Void

    public var body: some View {
        ZStack {
            Button(action: onFlip) {
                ZStack {
                    RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadius)
                        .fill(DesignSystem.Colors.cardBackground)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)

                    frontFace
                        .opacity(isFlipped ? 0 : 1)
                    
                    backFace
                        .opacity(isFlipped ? 1 : 0)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                }
            }
            .buttonStyle(.plain)
            
            if isFlipped {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: onPlayAudio) {
                            Image(systemName: "speaker.wave.2.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(DesignSystem.Colors.primary)
                                .background(Circle().fill(Color.white))
                        }
                        .padding(16)
                    }
                }
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
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
            Text(flashcard.hanzi)
                .font(.system(size: 80, weight: .bold, design: .rounded))
                .foregroundColor(DesignSystem.Colors.textPrimary)
        }
    }

    private var backFace: some View {
        VStack(spacing: 16) {
            if let imageRef = flashcard.imageRef {
                Image(systemName: imageRef)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .foregroundColor(DesignSystem.Colors.primary)
            }
            
            Text(flashcard.pinyin)
                .font(DesignSystem.Typography.title)
                .foregroundColor(DesignSystem.Colors.primary)

            Text(flashcard.indonesianTranslation)
                .font(DesignSystem.Typography.headline)
                .foregroundColor(DesignSystem.Colors.textPrimary)
        }
    }
}

#Preview {
    FlashcardView(
        flashcard: Flashcard(hanzi: "你好", pinyin: "nǐ hǎo", indonesianTranslation: "halo", imageRef: "hand.wave.fill", audioRef: ""),
        isFlipped: true,
        onFlip: { print("Flip card") },
        onPlayAudio: { print("Play Audio Tapped") }
    )
    .frame(height: 400)
    .padding()
}
