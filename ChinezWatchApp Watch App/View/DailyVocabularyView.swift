import Combine
//
//  DailyVocabularyView.swift
//  Chinez (watchOS)
//
//  Tampilan utama fitur Daily Vocabulary.
//  Menampilkan satu kosakata (hanzi, pinyin, arti) dengan tema merah–emas.
//  Konten di-center; tombol "Acak" (shuffle) berada di paling bawah.
//

import SwiftUI

struct DailyVocabularyView: View {
    @StateObject private var viewModel = DailyVocabularyViewModel()

    var body: some View {
        ZStack {
            // Latar gradien merah (selaras tema modul).
            LinearGradient(
                colors: [
                    Color(red: 126/255, green: 40/255, blue: 32/255),
                    Color(red: 178/255, green: 58/255, blue: 46/255)
                ],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            if let vocab = viewModel.current {
                VStack(spacing: 6) {
                    Spacer(minLength: 0)

                    // Hanzi (besar; mengecil otomatis bila perlu)
                    Text(vocab.hanzi)
                        .font(.system(size: 120, weight: .bold))
                        .foregroundStyle(Color(red: 251/255, green: 243/255, blue: 222/255))
                        .minimumScaleFactor(0.4)
                        .lineLimit(1)

                    // Pinyin (emas)
                    Text(vocab.pinyin)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color(red: 240/255, green: 216/255, blue: 122/255))

                    // Arti
                    Text(vocab.arti)
                        .font(.system(size: 14))
                        .foregroundStyle(Color(red: 251/255, green: 243/255, blue: 222/255).opacity(0.92))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 4)

                    Spacer(minLength: 0)

                    // Tombol Acak (shuffle) — ramping, otomatis di tengah (VStack .center).
                    Button(action: { viewModel.shuffle() }) {
                        HStack(spacing: 6) {
                            Image(systemName: "shuffle")
                            Text("Acak")
                        }
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(Color(red: 178/255, green: 58/255, blue: 46/255))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .background(
                            Capsule().fill(Color(red: 251/255, green: 243/255, blue: 222/255))
                        )
                        .overlay(
                            Capsule().strokeBorder(Color(red: 212/255, green: 175/255, blue: 55/255), lineWidth: 1.5)
                        )
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom, 2)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 8)
            } else {
                Text(viewModel.errorMessage ?? "Tidak ada kosakata.")
                    .font(.footnote)
                    .foregroundStyle(Color(red: 251/255, green: 243/255, blue: 222/255))
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
    }
}

#Preview {
    DailyVocabularyView()
}
