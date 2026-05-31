import SwiftUI

// MARK: - WritingQuizView
/// Interactive Hanzi stroke-order quiz using HanziWriter's built-in
/// `writer.quiz()` mode (per HanziWriterContext.md §4).
///
/// Architecture:
///   - HanziWebView with `useQuizMode: true` handles ALL touch interaction.
///   - No PencilKit overlay needed — HanziWriter validates strokes natively.
///   - JS sends `strokeCorrect` / `strokeMistake` / `quizComplete` messages
///     back to Swift via webkit.messageHandlers.
///   - Swift provides haptic feedback and manages quiz progression.
///
/// Data flow (per HanziWriterContext.md §2-3):
///   1. Swift reads character medians from `HSK1_StrokeData.json`
///   2. Injects as `injectedLocalData` into WKWebView
///   3. JS `charDataLoader` checks local data first, CDN fallback
///   4. `writer.quiz()` is called immediately after initialization
struct WritingQuizView: View {

    let level: WritingLevel

    // MARK: – State

    /// Index of the current character being quizzed.
    @State private var currentIndex: Int = 0

    /// The character string fed into the web view binding.
    @State private var currentCharacter: String = ""

    /// Controls the success overlay animation.
    @State private var showSuccessBanner: Bool = false

    /// Tracks total mistake count for the session.
    @State private var mistakeCount: Int = 0

    /// Number of correct strokes in the current character (for progress display).
    @State private var correctStrokesInChar: Int = 0

    // MARK: – Body

    var body: some View {
        VStack(spacing: DesignSystem.Dimensions.paddingStandard) {

            // ── Progress Header ─────────────────────────────────────────
            HStack {
                Text("Karakter \(currentIndex + 1) dari \(level.characters.count)")
                    .font(DesignSystem.Typography.subheadlineBold)
                    .foregroundColor(DesignSystem.Colors.textDark.opacity(0.7))
                Spacer()
                if mistakeCount > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 12))
                        Text("\(mistakeCount)")
                            .font(DesignSystem.Typography.subheadlineBold)
                    }
                    .foregroundColor(DesignSystem.Colors.error.opacity(0.7))
                }
            }
            .padding(.horizontal, DesignSystem.Dimensions.paddingLarge)
            .padding(.top, DesignSystem.Dimensions.paddingSmall)

            // ── Target Character (large display) ────────────────────────
            Text(currentCharacter)
                .font(.system(size: 80, weight: .bold))
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .frame(height: 100)

            // ── Interactive Quiz Canvas ──────────────────────────────────
            ZStack {
                RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadius, style: .continuous)
                    .fill(DesignSystem.Colors.secondaryBackground)

                // HanziWriter with quiz mode enabled — handles ALL touch input
                HanziWebView(
                    character: $currentCharacter,
                    useQuizMode: true,
                    onCorrectStroke: { strokeNum in
                        handleCorrectStroke(strokeNum)
                    },
                    onMistake: {
                        handleMistake()
                    },
                    onQuizComplete: {
                        handleQuizCompleted()
                    }
                )

                // ── Success overlay ─────────────────────────────────────
                if showSuccessBanner {
                    VStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 56))
                            .foregroundColor(DesignSystem.Colors.success)
                        Text("Benar!")
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

            // ── Hint Text ───────────────────────────────────────────────
            Text("Tulis guratan sesuai urutan yang benar")
                .font(DesignSystem.Typography.caption)
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .padding(.bottom, DesignSystem.Dimensions.paddingStandard)

            Spacer()
        }
        .background(DesignSystem.Colors.background.ignoresSafeArea())
        .navigationTitle(level.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            currentCharacter = level.characters.first ?? ""
        }
    }

    // MARK: – Handlers

    /// Fires when a single stroke is drawn correctly (via JS `strokeCorrect`).
    private func handleCorrectStroke(_ strokeNum: Int) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()

        correctStrokesInChar = strokeNum + 1
    }

    /// Fires on each incorrect stroke attempt (via JS `strokeMistake`).
    private func handleMistake() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)

        mistakeCount += 1
    }

    /// Fires when the user finishes all strokes correctly (via JS `quizComplete`).
    private func handleQuizCompleted() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)

        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            showSuccessBanner = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showSuccessBanner = false
            }

            // Advance to next character
            let nextIndex = currentIndex + 1
            if nextIndex < level.characters.count {
                currentIndex = nextIndex
                currentCharacter = level.characters[nextIndex]
                correctStrokesInChar = 0
            } else {
                // All characters done — loop back for practice
                currentIndex = 0
                currentCharacter = level.characters[0]
                mistakeCount = 0
                correctStrokesInChar = 0
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
#Preview {
    NavigationStack {
        WritingQuizView(level: .sample)
    }
}
#endif
