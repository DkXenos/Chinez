import SwiftUI

struct HomeView: View {
    @EnvironmentObject var router: NavigationRouter

    var body: some View {
        ZStack {
            DesignSystem.Colors.background
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {

                    // ── Greeting ────────────────────────────────
                    VStack(alignment: .leading, spacing: 6) {
                        Text(greetingText)
                            .font(DesignSystem.Typography.body)
                            .foregroundStyle(DesignSystem.Colors.textSecondary).opacity(0.8)

                        Text("Chinez")
                            .font(DesignSystem.Typography.largeTitle)
                            .foregroundStyle(DesignSystem.Colors.primary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, DesignSystem.Dimensions.paddingLarge)
                    .padding(.top, 12)

                    // ── Practice Pronunciation Card ─────────────
                    Button {
                        router.navigationPath.append(AppRoute.tonePractice)
                    } label: {
                        PronunciationCard()
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, DesignSystem.Dimensions.paddingLarge)

                    // ── Quick Actions Grid ──────────────────────
                    LazyVGrid(
                        columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)],
                        spacing: 16
                    ) {
                        Button {
                            router.navigationPath.append(AppRoute.courseList)
                        } label: {
                            QuickActionTile(
                                icon: "character.book.closed.fill",
                                title: "Courses",
                                subtitle: "Learn by topic",
                                gradient: [Color(red: 0.20, green: 0.55, blue: 0.95), Color(red: 0.30, green: 0.40, blue: 0.90)]
                            )
                        }
                        .buttonStyle(.plain)

                        Button {
                            router.openWritingQuiz()
                        } label: {
                            QuickActionTile(
                                icon: "pencil.tip.crop.circle",
                                title: "Writing",
                                subtitle: "Stroke order quiz",
                                gradient: [
                                    Color(red: 0.90, green: 0.45, blue: 0.30),
                                    Color(red: 0.85, green: 0.30, blue: 0.50)
                                ]
                            )
                        }
                        .buttonStyle(.plain)


                        Button {
                            router.navigationPath.append(AppRoute.dictionary)
                        } label: {
                            QuickActionTile(
                                icon: "book.fill",
                                title: "Dictionary",
                                subtitle: "Look up Hanzi",
                                gradient: [
                                    Color(red: 0.30, green: 0.78, blue: 0.55),
                                    Color(red: 0.20, green: 0.60, blue: 0.65)
                                ]
                            )
                        }
                        .buttonStyle(.plain)


                        Button {
                            router.navigationPath.append(AppRoute.progress)
                        } label: {
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
                        .buttonStyle(.plain)

                    }
                    .padding(.horizontal, DesignSystem.Dimensions.paddingLarge)

                    Spacer(minLength: 40)
                }
            }
        }
    }
}

// MARK: – Helpers

private var greetingText: String {
    let hour = Calendar.current.component(.hour, from: Date())
    switch hour {
    case 5..<12:  return "Good morning, start your day with.."
    case 12..<17: return "Good afternoon, let's spend some time with.."
    case 17..<21: return "Good evening, there's always a time with.."
    default:      return "Good night, end your day with.."
    }
}

// MARK: – Pronunciation Card

private struct PronunciationCard: View {
    var body: some View {
        HStack(spacing: 16) {
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
                    .font(DesignSystem.Typography.headline)
                    .foregroundColor(DesignSystem.Colors.textPrimary)

                Text("Train your Mandarin tones with AI feedback")
                    .font(DesignSystem.Typography.caption)
                    .foregroundColor(DesignSystem.Colors.secondary)
                    .lineLimit(2)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(DesignSystem.Colors.textPrimary)
        }
        .padding(DesignSystem.Dimensions.paddingStandard)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadius, style: .continuous)
                .fill(DesignSystem.Colors.secondaryBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadius, style: .continuous)
                        .strokeBorder(DesignSystem.Colors.secondary, lineWidth: 1)
                )
        )
    }
}

// MARK: – Quick Action Tile

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
                    .font(DesignSystem.Typography.headline)
                    .foregroundColor(DesignSystem.Colors.textPrimary)

                Text(subtitle)
                    .font(DesignSystem.Typography.caption)
                    .foregroundColor(DesignSystem.Colors.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DesignSystem.Dimensions.paddingStandard)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadius, style: .continuous)
                .fill(DesignSystem.Colors.secondaryBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadius, style: .continuous)
                        .strokeBorder(DesignSystem.Colors.secondary, lineWidth: 1)
                )
        )
    }
}

#Preview {
    HomeView()
        .environmentObject(NavigationRouter())
}
