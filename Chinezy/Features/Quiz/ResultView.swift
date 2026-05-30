//
//  ResultView.swift
//  Chinez
//
//

import SwiftUI

struct ResultView: View {
    let correct: Int
    let wrong: Int
    let total: Int
    let percentage: Int
    let chapterTitle: String
    let onRetry: () -> Void
    let onBackToList: () -> Void

    var body: some View {
        VStack(spacing: 26) {
            Spacer(minLength: 8)

            scoreRing

            VStack(spacing: 6) {
                Text(headline)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(Color(red: 43/255, green: 43/255, blue: 43/255))
                    .multilineTextAlignment(.center)
                Text(chapterTitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 14) {
                ScorePill(count: correct, label: "Benar",
                          tint: Color(red: 212/255, green: 175/255, blue: 55/255), icon: "checkmark.circle.fill")
                ScorePill(count: wrong, label: "Salah",
                          tint: Color(red: 178/255, green: 58/255, blue: 46/255), icon: "xmark.circle.fill")
            }
            .padding(.horizontal, 24)

            Spacer(minLength: 8)

            actionButtons
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }

    // MARK: - Ring skor

    private var scoreRing: some View {
        ZStack {
            Circle().stroke(Color(red: 251/255, green: 246/255, blue: 234/255), lineWidth: 16)
            Circle()
                .trim(from: 0, to: CGFloat(percentage) / 100)
                .stroke(
                    LinearGradient(
                        colors: [Color(red: 178/255, green: 58/255, blue: 46/255), Color(red: 212/255, green: 175/255, blue: 55/255)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 16, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            VStack(spacing: 0) {
                Text("\(percentage)%")
                    .font(.system(size: 46, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(red: 178/255, green: 58/255, blue: 46/255))
                Text("\(correct)/\(total) benar")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 200, height: 200)
    }

    // MARK: - Tombol aksi

    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: onRetry) {
                Label("Ulangi Quiz", systemImage: "arrow.clockwise")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
            .background(Color(red: 178/255, green: 58/255, blue: 46/255))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            Button(action: onBackToList) {
                Text("Kembali ke Daftar Bab")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
            .foregroundStyle(Color(red: 178/255, green: 58/255, blue: 46/255))
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(Color(red: 178/255, green: 58/255, blue: 46/255), lineWidth: 1.5)
            )
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
    }

    private var headline: String {
        switch percentage {
        case 90...100: return "Luar Biasa! 太棒了"
        case 70..<90:  return "Bagus Sekali!"
        case 50..<70:  return "Lumayan — Terus Berlatih!"
        default:       return "Jangan Menyerah!"
        }
    }
}

// MARK: - Kartu skor (Benar / Salah)

private struct ScorePill: View {
    let count: Int
    let label: String
    let tint: Color
    let icon: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(tint)
            Text("\(count)")
                .font(.system(size: 30, weight: .heavy, design: .rounded))
                .foregroundStyle(Color(red: 43/255, green: 43/255, blue: 43/255))
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(red: 251/255, green: 246/255, blue: 234/255))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(tint.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    ResultView(correct: 8, wrong: 2, total: 10, percentage: 80,
               chapterTitle: "Makanan & Minuman",
               onRetry: {}, onBackToList: {})
}
