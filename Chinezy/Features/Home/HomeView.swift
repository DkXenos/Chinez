import SwiftUI

struct HomeView: View {
    @EnvironmentObject var router: NavigationRouter

    /// Ambient gradient animation state
    @State private var animateGradient: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                // ── Animated Background ─────────────────────────
                LinearGradient(
                    colors: [
                        Color(red: 0.06, green: 0.07, blue: 0.14),
                        Color(red: 0.10, green: 0.12, blue: 0.24),
                        Color(red: 0.06, green: 0.07, blue: 0.14)
                    ],
                    startPoint: animateGradient ? .topLeading : .bottomLeading,
                    endPoint: animateGradient ? .bottomTrailing : .topTrailing
                )
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.easeInOut(duration: 6).repeatForever(autoreverses: true)) {
                        animateGradient.toggle()
                    }
                }

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {

                        // ── Greeting ────────────────────────────────
                        VStack(alignment: .leading, spacing: 6) {
                            Text(greetingText)
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.5))

                            Text("Chinez")
                                .font(.system(size: 34, weight: .heavy, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.40, green: 0.75, blue: 1.0),
                                            Color(red: 0.60, green: 0.50, blue: 1.0)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, DesignSystem.Dimensions.paddingLarge)
                        .padding(.top, 12)

                        // ── Practice Pronunciation Card ─────────────
                        NavigationLink(destination: TonePracticeView().environmentObject(router)) {
                            PronunciationCard()
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, DesignSystem.Dimensions.paddingLarge)

                        // ── Quick Actions Grid ──────────────────────
                        LazyVGrid(
                            columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)],
                            spacing: 16
                        ) {
                            QuickActionTile(
                                icon: "character.book.closed.fill",
                                title: "Themes",
                                subtitle: "Learn by topic",
                                gradient: [
                                    Color(red: 0.20, green: 0.55, blue: 0.95),
                                    Color(red: 0.30, green: 0.40, blue: 0.90)
                                ]
                            )

                            QuickActionTile(
                                icon: "pencil.tip.crop.circle",
                                title: "Free Draw",
                                subtitle: "Practice strokes",
                                gradient: [
                                    Color(red: 0.90, green: 0.45, blue: 0.30),
                                    Color(red: 0.85, green: 0.30, blue: 0.50)
                                ]
                            )

                            QuickActionTile(
                                icon: "book.fill",
                                title: "Dictionary",
                                subtitle: "Look up Hanzi",
                                gradient: [
                                    Color(red: 0.30, green: 0.78, blue: 0.55),
                                    Color(red: 0.20, green: 0.60, blue: 0.65)
                                ]
                            )

                            QuickActionTile(
                                icon: "chart.bar.fill",
                                title: "Progress",
                                subtitle: "Your stats",
                                gradient: [
                                    Color(red: 0.85, green: 0.65, blue: 0.20),
                                    Color(red: 0.90, green: 0.45, blue: 0.20)
                                ]
                            )
                        }
                        .padding(.horizontal, DesignSystem.Dimensions.paddingLarge)

                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }

    // MARK: – Helpers

    /// Returns a time‑of‑day greeting.
    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:  return "Good morning ☀️"
        case 12..<17: return "Good afternoon 🌤️"
        case 17..<21: return "Good evening 🌙"
        default:      return "Good night 🌙"
        }
    }
}

// MARK: – Pronunciation Card

/// A large, visually prominent card that navigates to TonePracticeView.
private struct PronunciationCard: View {
    @State private var hovered = false

    var body: some View {
        HStack(spacing: 16) {
            // Icon
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
                    .frame(width: 56, height: 56)

                Image(systemName: "waveform.and.mic")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Practice Pronunciation")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                Text("Train your Mandarin tones with AI feedback")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.55))
                    .lineLimit(2)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white.opacity(0.3))
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(.ultraThinMaterial.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.18),
                                    .white.opacity(0.04)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .environment(\.colorScheme, .dark)
    }
}

// MARK: – Quick Action Tile

/// Small grid tiles for secondary navigation items.
private struct QuickActionTile: View {
    let icon: String
    let title: String
    let subtitle: String
    let gradient: [Color]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: gradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 42, height: 42)

                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                Text(subtitle)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.45))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.ultraThinMaterial.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.12),
                                    .white.opacity(0.03)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .environment(\.colorScheme, .dark)
    }
}

// MARK: – Preview

#Preview {
    HomeView()
        .environmentObject(NavigationRouter())
}
