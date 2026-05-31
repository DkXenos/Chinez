//
//  QuizSessionView.swift
//  Chinez
//
//  Layar pengerjaan satu sesi kuis (untuk satu bab).
//  Alur tiap soal: pilih opsi A–D → tombol "Periksa" menampilkan benar/salah
//  (opsi benar disorot hijau; bila salah, pilihan user merah + jawaban benar
//  ditampilkan) → tombol "Lanjut" untuk ke soal berikutnya.
//  Saat 10 soal selesai, otomatis menampilkan ResultView.
//

import SwiftUI

struct QuizSessionView: View {
    @StateObject private var viewModel: QuizViewModel
    @Environment(\.dismiss) private var dismiss

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
        .background(Color.white)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.isFinished ? "Hasil" : "Bab \(viewModel.chapter.id)")
    }

    // MARK: - Konten Soal

    private var questionContent: some View {
        VStack(spacing: 0) {
            QuizProgressBar(progress: viewModel.progress)
                .padding(.horizontal, 20)
                .padding(.top, 14)

            HStack {
                Text("Soal \(viewModel.questionNumber) dari \(viewModel.totalQuestions)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color(red: 43/255, green: 43/255, blue: 43/255).opacity(0.7))
                Spacer()
                TypeBadge(text: viewModel.currentQuestion.type)
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)

            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    // Kartu pertanyaan
                    Text(viewModel.currentQuestion.stem)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(Color(red: 43/255, green: 43/255, blue: 43/255))
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(18)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color(red: 251/255, green: 246/255, blue: 234/255))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .strokeBorder(Color(red: 212/255, green: 175/255, blue: 55/255).opacity(0.5), lineWidth: 1)
                        )

                    // Opsi A–D
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

            // Feedback benar/salah (muncul setelah "Periksa")
            if viewModel.isRevealed {
                feedbackBanner
                    .padding(.horizontal, 20)
                    .padding(.bottom, 6)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            // Tombol: Periksa → Lanjut / Lihat Hasil
            Button(action: primaryAction) {
                Text(buttonTitle)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
            .background(buttonEnabled
                        ? Color(red: 178/255, green: 58/255, blue: 46/255)
                        : Color(red: 178/255, green: 58/255, blue: 46/255).opacity(0.3))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .disabled(!buttonEnabled)
            .animation(.easeInOut(duration: 0.15), value: buttonEnabled)
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
    }

    // MARK: - Feedback banner

    @ViewBuilder
    private var feedbackBanner: some View {
        if viewModel.isCurrentCorrect {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                Text("Benar!")
                Spacer(minLength: 0)
            }
            .font(.subheadline.weight(.bold))
            .foregroundStyle(Color(red: 30/255, green: 140/255, blue: 95/255))
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(red: 30/255, green: 140/255, blue: 95/255).opacity(0.10))
            )
        } else {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Image(systemName: "xmark.circle.fill")
                    Text("Salah")
                }
                .font(.subheadline.weight(.bold))
                .foregroundStyle(Color(red: 178/255, green: 58/255, blue: 46/255))

                Text("Jawaban yang benar: \(viewModel.correctAnswerText)")
                    .font(.subheadline)
                    .foregroundStyle(Color(red: 43/255, green: 43/255, blue: 43/255))
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(red: 178/255, green: 58/255, blue: 46/255).opacity(0.08))
            )
        }
    }

    // MARK: - Helpers

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

// MARK: - Status tampilan opsi

private enum OptionState {
    case idle      // belum diperiksa, tidak dipilih
    case selected  // belum diperiksa, dipilih (merah)
    case correct   // sudah diperiksa, ini jawaban benar (hijau)
    case wrong     // sudah diperiksa, ini pilihan user yang salah (merah)
    case dimmed    // sudah diperiksa, opsi lain (redup)
}

// MARK: - Progress Bar

private struct QuizProgressBar: View {
    let progress: Double

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Color(red: 251/255, green: 246/255, blue: 234/255))
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 178/255, green: 58/255, blue: 46/255), Color(red: 212/255, green: 175/255, blue: 55/255)],
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

// MARK: - Badge Tipe Soal

private struct TypeBadge: View {
    let text: String

    var body: some View {
        Text(text.uppercased())
            .font(.system(size: 9, weight: .heavy))
            .tracking(0.5)
            .foregroundStyle(Color(red: 126/255, green: 40/255, blue: 32/255))
            .padding(.horizontal, 9)
            .padding(.vertical, 4)
            .background(Capsule().fill(Color(red: 240/255, green: 216/255, blue: 122/255).opacity(0.45)))
            .overlay(Capsule().strokeBorder(Color(red: 212/255, green: 175/255, blue: 55/255).opacity(0.5), lineWidth: 0.5))
    }
}

// MARK: - Tombol Opsi (warna mengikuti OptionState)

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
                RoundedRectangle(cornerRadius: 14, style: .continuous).fill(backgroundFill)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(borderColor, lineWidth: borderWidth)
            )
        }
        .buttonStyle(.plain)
    }

    private var backgroundFill: Color {
        switch state {
        case .idle, .dimmed: return .white
        case .selected:      return Color(red: 178/255, green: 58/255, blue: 46/255).opacity(0.06)
        case .correct:       return Color(red: 30/255, green: 140/255, blue: 95/255).opacity(0.10)
        case .wrong:         return Color(red: 178/255, green: 58/255, blue: 46/255).opacity(0.10)
        }
    }

    private var borderColor: Color {
        switch state {
        case .idle:             return Color.black.opacity(0.12)
        case .dimmed:           return Color.black.opacity(0.07)
        case .selected, .wrong: return Color(red: 178/255, green: 58/255, blue: 46/255)
        case .correct:          return Color(red: 30/255, green: 140/255, blue: 95/255)
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
        case .idle, .dimmed:    return Color(red: 251/255, green: 246/255, blue: 234/255)
        case .selected, .wrong: return Color(red: 178/255, green: 58/255, blue: 46/255)
        case .correct:          return Color(red: 30/255, green: 140/255, blue: 95/255)
        }
    }

    private var circleText: Color {
        switch state {
        case .idle:                        return Color(red: 126/255, green: 40/255, blue: 32/255)
        case .dimmed:                      return Color.gray
        case .selected, .correct, .wrong:  return .white
        }
    }

    private var textColor: Color {
        switch state {
        case .dimmed: return Color(red: 43/255, green: 43/255, blue: 43/255).opacity(0.5)
        default:      return Color(red: 43/255, green: 43/255, blue: 43/255)
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
        case .correct: return Color(red: 30/255, green: 140/255, blue: 95/255)
        case .wrong:   return Color(red: 178/255, green: 58/255, blue: 46/255)
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
