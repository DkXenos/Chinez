import Combine
import SwiftUI

struct WritingQuizView: View {

    let level: WritingLevel
    @StateObject private var viewModel: WritingQuizViewModel
    @Environment(\.dismiss) private var dismiss

    init(level: WritingLevel) {
        self.level = level
        _viewModel = StateObject(wrappedValue: WritingQuizViewModel(level: level))
    }

    var body: some View {
        VStack(spacing: DesignSystem.Dimensions.paddingStandard) {
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

            Text(viewModel.currentCharacter)
                .font(.system(size: 80, weight: .bold))
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .frame(height: 100)

            ZStack {
                RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadius, style: .continuous)
                    .fill(DesignSystem.Colors.secondaryBackground)

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
                    }
                )

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
