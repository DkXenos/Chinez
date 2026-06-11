import Combine

import SwiftUI

struct ChapterListView: View {
    @StateObject private var viewModel = ChapterListViewModel()

    var body: some View {
        content
            .navigationTitle("Quiz")
            .navigationDestination(for: Chapter.self) { chapter in
                QuizSessionView(viewModel: QuizViewModel(chapter: chapter))
            }
            .tint(DesignSystem.Colors.primary)
    }

    @ViewBuilder
    private var content: some View {
        if let error = viewModel.errorMessage {
            errorView(message: error)
        } else {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.chapters) { chapter in
                        NavigationLink(value: chapter) {
                            ChapterRow(chapter: chapter)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .foregroundColor(DesignSystem.Colors.primary)
        }
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundStyle(DesignSystem.Colors.primary)
            Text("Gagal Memuat Soal")
                .font(.headline)
                .foregroundStyle(DesignSystem.Colors.textDark)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DesignSystem.Colors.surfaceWhite)
    }
}


private struct ChapterRow: View {
    let chapter: Chapter

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadiusMedium, style: .continuous)
                    .fill(DesignSystem.Colors.background)
                RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadiusMedium, style: .continuous)
                    .strokeBorder(DesignSystem.Colors.gold, lineWidth: 1.5)
                Text(chapter.hanzi)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(DesignSystem.Colors.primary)
            }
            .frame(width: 54, height: 54)

            VStack(alignment: .leading, spacing: 4) {
                Text("BAB \(chapter.id)")
                    .font(.system(size: 10, weight: .heavy))
                    .tracking(1)
                    .foregroundStyle(DesignSystem.Colors.primaryDark)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 2)
                    .background(Capsule().fill(DesignSystem.Colors.goldLight.opacity(0.5)))

                Text(chapter.title)
                    .font(.headline)
                    .foregroundStyle(DesignSystem.Colors.textDark)

                Text("\(chapter.questionCount) soal")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 8)

            Image(systemName: "chevron.right")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(DesignSystem.Colors.primary.opacity(0.45))
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadius, style: .continuous)
                .fill(DesignSystem.Colors.surfaceWhite)
                .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadius, style: .continuous)
                .strokeBorder(DesignSystem.Colors.primary.opacity(0.08), lineWidth: 1)
        )
    }
}

#Preview {
    ChapterListView()
}
