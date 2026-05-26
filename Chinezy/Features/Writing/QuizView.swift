import SwiftUI

// MARK: - QuizView
/// A standalone SwiftUI view demonstrating the Hanzi Writer stroke-order
/// quiz with the layered architecture:
///   Bottom — HanziWebView (animation renderer, no touch)
///   Top    — StrokeCanvasView (PencilKit / touch drawing)
///
/// When the native StrokeValidator confirms a correct stroke, the parent
/// tells HanziWebView to animate that stroke via the coordinator bridge.
struct QuizView: View {

    // MARK: – State

    /// The list of characters to cycle through in the quiz.
    private let characters: [String] = ["测", "试", "你", "好", "我"]

    /// Index of the current character being quizzed.
    @State private var currentIndex: Int = 0

    /// The character string fed into the web view binding.
    @State private var currentCharacter: String = "测"

    /// Controls the "Quiz Passed!" overlay animation.
    @State private var showSuccessBanner: Bool = false

    /// Tracks total mistake count for the session.
    @State private var mistakeCount: Int = 0

    /// Reference to the HanziWebView coordinator for triggering animations.
    @State private var hanziCoordinator: HanziWebView.Coordinator?

    // MARK: – Body

    var body: some View {
        VStack(spacing: DesignSystem.Dimensions.paddingStandard) {

            // ── Progress Indicator ──────────────────────────────────
            Text("\(currentIndex + 1) / \(characters.count)")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .padding(.top, DesignSystem.Dimensions.paddingLarge)

            // ── Target Character (large display) ────────────────────
            Text(currentCharacter)
                .font(.system(size: 100, weight: .bold))
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .padding(.top, DesignSystem.Dimensions.paddingStandard)

            Spacer()

            // ── Layered Canvas ──────────────────────────────────────
            ZStack {
                RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadius, style: .continuous)
                    .fill(DesignSystem.Colors.secondaryBackground)

                // Layer 1: Hanzi Writer animation renderer
                HanziWebView(
                    character: $currentCharacter,
                    onAllStrokesCompleted: nil,
                    onCoordinatorReady: { coordinator in
                        hanziCoordinator = coordinator
                    }
                )

                // Layer 2: PencilKit drawing input
                StrokeCanvasView(
                    character: currentCharacter,
                    onCharacterFinished: {
                        handleQuizCompleted()
                    },
                    onMistake: {
                        handleMistake()
                    },
                    onCorrectStroke: { strokeIndex in
                        hanziCoordinator?.animateStroke(at: strokeIndex)
                    }
                )
                .id(currentCharacter)

                // ── Success overlay ─────────────────────────────────
                if showSuccessBanner {
                    VStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 56))
                            .foregroundColor(Color(red: 0.2, green: 0.78, blue: 0.35))
                        Text("Quiz Passed!")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                    }
                    .transition(.scale.combined(with: .opacity))
                    .allowsHitTesting(false)
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .clipShape(
                RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadius, style: .continuous)
            )
            .padding(.horizontal, DesignSystem.Dimensions.paddingLarge)

            Spacer()

            // ── Mistake counter ─────────────────────────────────────
            if mistakeCount > 0 {
                Text("Mistakes: \(mistakeCount)")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .padding(.bottom, DesignSystem.Dimensions.paddingStandard)
            }
        }
        .background(DesignSystem.Colors.background.ignoresSafeArea())
    }

    // MARK: – Handlers

    /// Fires when the user finishes all strokes correctly.
    private func handleQuizCompleted() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)

        print("Quiz Passed! Character: \(currentCharacter)")

        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            showSuccessBanner = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation {
                showSuccessBanner = false
            }

            let nextIndex = currentIndex + 1
            if nextIndex < characters.count {
                currentIndex = nextIndex
                currentCharacter = characters[nextIndex]
            } else {
                print("🎉 All characters completed!")
                currentIndex = 0
                currentCharacter = characters[0]
                mistakeCount = 0
            }
        }
    }

    /// Fires on each incorrect stroke attempt.
    private func handleMistake() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)

        mistakeCount += 1
        print("Mistake #\(mistakeCount) on character: \(currentCharacter)")
    }
}

// MARK: - Preview

#Preview {
    QuizView()
}
