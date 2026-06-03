import Combine
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
    @StateObject private var viewModel: WritingQuizViewModel
    @State private var isLoaded: Bool = false
    @Environment(\.dismiss) private var dismiss

    init(level: WritingLevel) {
        self.level = level
        _viewModel = StateObject(wrappedValue: WritingQuizViewModel(level: level))
    }

    // MARK: – Body

    var body: some View {
        VStack(spacing: DesignSystem.Dimensions.paddingStandard) {

            // ── Progress Header ─────────────────────────────────────────
            HStack {
                Text("Karakter \(viewModel.currentIndex + 1) dari \(level.characters.count)")
                    .font(DesignSystem.Typography.subheadlineBold)
                    .foregroundColor(DesignSystem.Colors.textDark.opacity(0.7))
                Spacer()
                if viewModel.mistakeCount > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 12))
                        Text("\(viewModel.mistakeCount)")
                            .font(DesignSystem.Typography.subheadlineBold)
                    }
                    .foregroundColor(DesignSystem.Colors.error.opacity(0.7))
                }
            }
            .padding(.horizontal, DesignSystem.Dimensions.paddingLarge)
            .padding(.top, DesignSystem.Dimensions.paddingSmall)

            // ── Target Character (large display) ────────────────────────
            Text(viewModel.currentCharacter)
                .font(.system(size: 80, weight: .bold))
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .frame(height: 100)

            // ── Interactive Quiz Canvas ──────────────────────────────────
            ZStack {
                RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadius, style: .continuous)
                    .fill(DesignSystem.Colors.secondaryBackground)

                // HanziWriter with quiz mode enabled — handles ALL touch input
                HanziWebView(
                    character: $viewModel.currentCharacter,
                    useQuizMode: true,
                    onCorrectStroke: { strokeNum in
                        viewModel.handleCorrectStroke(strokeNum)
                    },
                    onMistake: {
                        viewModel.handleMistake()
                    },
                    onQuizComplete: {
                        viewModel.handleQuizCompleted()
                    },
                    onLoaded: {
                        withAnimation(.easeInOut) {
                            isLoaded = true
                        }
                    }
                )

                if !isLoaded {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                        .transition(.opacity)
                }

                // ── Success overlay ─────────────────────────────────────
                if viewModel.showSuccessBanner {
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
            viewModel.onFinish = {
                dismiss()
            }
            viewModel.onAppear()
        }
        .onChange(of: viewModel.currentCharacter) { _ in
            isLoaded = false
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
