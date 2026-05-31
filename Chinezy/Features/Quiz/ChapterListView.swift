//
//  ChapterListView.swift
//  Chinez
//
//

import SwiftUI

struct ChapterListView: View {
    @StateObject private var viewModel = ChapterListViewModel()

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Quiz")
                .navigationDestination(for: Chapter.self) { chapter in
                    QuizSessionView(viewModel: QuizViewModel(chapter: chapter))
                }
        }
        .tint(Color(red: 178/255, green: 58/255, blue: 46/255))
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
            .background(Color.white)
        }
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundStyle(Color(red: 178/255, green: 58/255, blue: 46/255))
            Text("Gagal Memuat Soal")
                .font(.headline)
                .foregroundStyle(Color(red: 43/255, green: 43/255, blue: 43/255))
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

// MARK: - Baris Bab

private struct ChapterRow: View {
    let chapter: Chapter

    var body: some View {
        HStack(spacing: 14) {
            // Ikon Hanzi dekoratif dengan ring emas.
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(red: 251/255, green: 246/255, blue: 234/255))
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(Color(red: 212/255, green: 175/255, blue: 55/255), lineWidth: 1.5)
                Text(chapter.hanzi)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color(red: 178/255, green: 58/255, blue: 46/255))
            }
            .frame(width: 54, height: 54)

            VStack(alignment: .leading, spacing: 4) {
                Text("BAB \(chapter.id)")
                    .font(.system(size: 10, weight: .heavy))
                    .tracking(1)
                    .foregroundStyle(Color(red: 126/255, green: 40/255, blue: 32/255))
                    .padding(.horizontal, 7)
                    .padding(.vertical, 2)
                    .background(Capsule().fill(Color(red: 240/255, green: 216/255, blue: 122/255).opacity(0.5)))

                Text(chapter.title)
                    .font(.headline)
                    .foregroundStyle(Color(red: 43/255, green: 43/255, blue: 43/255))

                Text("\(chapter.questionCount) soal")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 8)

            Image(systemName: "chevron.right")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color(red: 178/255, green: 58/255, blue: 46/255).opacity(0.45))
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color(red: 178/255, green: 58/255, blue: 46/255).opacity(0.08), lineWidth: 1)
        )
    }
}

#Preview {
    ChapterListView()
}
