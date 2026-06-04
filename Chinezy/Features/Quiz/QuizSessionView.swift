import Combine

import SwiftUI

struct QuizSessionView: View {
    @StateObject private var viewModel: QuizViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authManager: AuthManager

    init(viewModel: QuizViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Group {
            if viewModel.isFinished {
                ResultView(
                    correct: viewModel.correctCount,
                    wrong: viewModel.wrongCount,
                    total: viewModel.totalQuestions,
                    percentage: viewModel.scorePercentage,
                    chapterTitle: viewModel.chapter.title,
                    onRetry: { viewModel.restart() },
                    onBackToList: { dismiss() }
                )
            } else {
                questionContent
            }
        }
        .background(DesignSystem.Colors.surfaceWhite)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.isFinished ? "Hasil" : "Bab \(viewModel.chapter.id)")
        .onChange(of: viewModel.isFinished) { isFinished in
            if isFinished {
                Task {
                    await authManager.saveQuizScore(quizId: String(viewModel.chapter.id), percentage: viewModel.scorePercentage)
                }
            }
        }
    }


    private var questionContent: some View {
        VStack(spacing: 0) {
            QuizProgressBar(progress: viewModel.progress)
                .padding(.horizontal, 20)
                .padding(.top, 14)

            HStack {
                Text("Soal \(viewModel.questionNumber) dari \(viewModel.totalQuestions)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(DesignSystem.Colors.textDark.opacity(0.7))
                Spacer()
                TypeBadge(text: viewModel.currentQuestion.type)
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)

            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    Text(viewModel.currentQuestion.stem)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(DesignSystem.Colors.textDark)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(18)
                        .background(
                            RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadius, style: .continuous)
                                .fill(DesignSystem.Colors.background)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadius, style: .continuous)
                                .strokeBorder(DesignSystem.Colors.cardBorder, lineWidth: 1)
                        )

                    VStack(spacing: 12) {
                        ForEach(Array(viewModel.currentQuestion.options.enumerated()), id: \.offset) { index, option in
                            OptionButton(
                                letter: Self.letters[index],
                                text: option,
                                state: optionState(for: index)
                            ) {
                                withAnimation(.easeInOut(duration: 0.12)) {
                                    viewModel.select(index)
                                }
                            }
                        }
                    }
                }
                .padding(20)
            }

            if viewModel.isRevealed {
                feedbackBanner
                    .padding(.horizontal, 20)
                    .padding(.bottom, 6)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            Button(action: primaryAction) {
                Text(buttonTitle)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
            .background(buttonEnabled
                        ? DesignSystem.Colors.primary
                        : DesignSystem.Colors.primary.opacity(0.3))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadiusMedium, style: .continuous))
            .disabled(!buttonEnabled)
            .animation(.easeInOut(duration: 0.15), value: buttonEnabled)
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
    }


    @ViewBuilder
    private var feedbackBanner: some View {
        if viewModel.isCurrentCorrect {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                Text("Benar!")
                Spacer(minLength: 0)
            }
            .font(.subheadline.weight(.bold))
            .foregroundStyle(DesignSystem.Colors.success)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadiusSmall, style: .continuous)
                    .fill(DesignSystem.Colors.success.opacity(0.10))
            )
        } else {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Image(systemName: "xmark.circle.fill")
                    Text("Salah")
                }
                .font(.subheadline.weight(.bold))
                .foregroundStyle(DesignSystem.Colors.error)

                Text("Jawaban yang benar: \(viewModel.correctAnswerText)")
                    .font(.subheadline)
                    .foregroundStyle(DesignSystem.Colors.textDark)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadiusSmall, style: .continuous)
                    .fill(DesignSystem.Colors.error.opacity(0.08))
            )
        }
    }


    private func optionState(for index: Int) -> OptionState {
        if viewModel.isRevealed {
            if index == viewModel.correctIndex { return .correct }
            if index == viewModel.selectedOption { return .wrong }
            return .dimmed
        } else {
            return viewModel.selectedOption == index ? .selected : .idle
        }
    }

    private var buttonTitle: String {
        if !viewModel.isRevealed { return "Periksa" }
        return viewModel.isLastQuestion ? "Lihat Hasil" : "Lanjut"
    }

    private var buttonEnabled: Bool {
        viewModel.isRevealed ? true : viewModel.hasSelection
    }

    private func primaryAction() {
        withAnimation(.easeInOut(duration: 0.2)) {
            if viewModel.isRevealed {
                viewModel.advance()
            } else {
                viewModel.submit()
            }
        }
    }

    private static let letters = ["A", "B", "C", "D"]
}



private enum OptionState {
    case idle
    case selected
    case correct
    case wrong
    case dimmed
}


private struct QuizProgressBar: View {
    let progress: Double

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(DesignSystem.Colors.background)
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [DesignSystem.Colors.primary, DesignSystem.Colors.gold],
                            startPoint: .leading, endPoint: .trailing
                        )
                    )
                    .frame(width: max(0, geo.size.width * progress))
            }
        }
        .frame(height: 8)
        .animation(.easeInOut(duration: 0.25), value: progress)
    }
}


private struct TypeBadge: View {
    let text: String

    var body: some View {
        Text(text.uppercased())
            .font(.system(size: 9, weight: .heavy))
            .tracking(0.5)
            .foregroundStyle(DesignSystem.Colors.primaryDark)
            .padding(.horizontal, 9)
            .padding(.vertical, 4)
            .background(Capsule().fill(DesignSystem.Colors.goldLight.opacity(0.45)))
            .overlay(Capsule().strokeBorder(DesignSystem.Colors.cardBorder, lineWidth: 0.5))
    }
}


private struct OptionButton: View {
    let letter: String
    let text: String
    let state: OptionState
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    Circle().fill(circleFill)
                    Text(letter)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(circleText)
                }
                .frame(width: 32, height: 32)

                Text(text)
                    .font(.system(size: 17))
                    .foregroundStyle(textColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)

                if let icon = trailingIcon {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(iconColor)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 14)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadiusMedium, style: .continuous).fill(backgroundFill)
            )
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadiusMedium, style: .continuous)
                    .strokeBorder(borderColor, lineWidth: borderWidth)
            )
        }
        .buttonStyle(.plain)
    }

    private var backgroundFill: Color {
        switch state {
        case .idle, .dimmed: return DesignSystem.Colors.surfaceWhite
        case .selected:      return DesignSystem.Colors.error.opacity(0.06)
        case .correct:       return DesignSystem.Colors.success.opacity(0.10)
        case .wrong:         return DesignSystem.Colors.error.opacity(0.10)
        }
    }

    private var borderColor: Color {
        switch state {
        case .idle:             return Color.black.opacity(0.12)
        case .dimmed:           return Color.black.opacity(0.07)
        case .selected, .wrong: return DesignSystem.Colors.error
        case .correct:          return DesignSystem.Colors.success
        }
    }

    private var borderWidth: CGFloat {
        switch state {
        case .idle, .dimmed:              return 1
        case .selected, .correct, .wrong: return 2
        }
    }

    private var circleFill: Color {
        switch state {
        case .idle, .dimmed:    return DesignSystem.Colors.background
        case .selected, .wrong: return DesignSystem.Colors.error
        case .correct:          return DesignSystem.Colors.success
        }
    }

    private var circleText: Color {
        switch state {
        case .idle:                        return DesignSystem.Colors.primaryDark
        case .dimmed:                      return Color.gray
        case .selected, .correct, .wrong:  return .white
        }
    }

    private var textColor: Color {
        switch state {
        case .dimmed: return DesignSystem.Colors.textDark.opacity(0.5)
        default:      return DesignSystem.Colors.textDark
        }
    }

    private var trailingIcon: String? {
        switch state {
        case .correct: return "checkmark.circle.fill"
        case .wrong:   return "xmark.circle.fill"
        default:       return nil
        }
    }

    private var iconColor: Color {
        switch state {
        case .correct: return DesignSystem.Colors.success
        case .wrong:   return DesignSystem.Colors.error
        default:       return .clear
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        QuizSessionView(viewModel: QuizViewModel(chapter: .sample))
    }
}
#endif
