import Combine
import SwiftUI

struct PartSelectionView: View {
    let theme: Theme
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var viewModel = PartSelectionViewModel()
    
    var body: some View {
        List {
            // ── Tone Practice shortcut ──────────────────────
            Section {
                NavigationLink(destination: TonePracticeView()) {
                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.95, green: 0.35, blue: 0.50),
                                            Color(red: 0.85, green: 0.25, blue: 0.65)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 44, height: 44)

                            Image(systemName: "waveform.and.mic")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Practice Pronunciation")
                                .font(DesignSystem.Typography.headline)
                                .foregroundColor(DesignSystem.Colors.textPrimary)
                            Text("Train your Mandarin tones")
                                .font(DesignSystem.Typography.caption)
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                        }
                    }
                    .padding(.vertical, 6)
                }
            }

            // ── Parts ───────────────────────────────────────
            Section {
                ForEach(viewModel.parts) { part in
                    Button(action: {
                        router.startExercise(part: part)
                    }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(part.name)
                                    .font(DesignSystem.Typography.headline)
                                    .foregroundColor(DesignSystem.Colors.textPrimary)
                                Text("\(part.characterCount) characters")
                                    .font(DesignSystem.Typography.caption)
                                    .foregroundColor(DesignSystem.Colors.textSecondary)
                            }

                            Spacer()

                            CircularProgressView(progress: part.progress)
                                .frame(width: 40, height: 40)
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
        }
        .navigationTitle(theme.name)
        .background(DesignSystem.Colors.background.ignoresSafeArea())
    }
}

struct CircularProgressView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(DesignSystem.Colors.secondaryBackground, lineWidth: 4)
            Circle()
                .trim(from: 0, to: CGFloat(progress))
                .stroke(DesignSystem.Colors.primary, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}

#Preview {
    PartSelectionView(theme: Theme(name: "Airport", iconName: "airplane", isLocked: false))
}
