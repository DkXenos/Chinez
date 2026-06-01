import SwiftUI

// MARK: - Tone List View (Landing page for the Tones tab)

struct ToneListView: View {
    @EnvironmentObject var router: NavigationRouter

    let toneGroups = ToneGroup.allGroups

    var body: some View {
        ScrollView {
            LazyVStack(spacing: DesignSystem.Dimensions.paddingStandard) {
                ForEach(toneGroups) { group in
                    NavigationLink(value: group) {
                        ToneGroupRow(group: group)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(DesignSystem.Dimensions.paddingStandard)
        }
        .navigationTitle("Tones")
        .background(DesignSystem.Colors.background.ignoresSafeArea())
        .navigationDestination(for: ToneGroup.self) { group in
            ToneGroupDetailView(group: group)
        }
    }
}

// MARK: - Tone Group Row

struct ToneGroupRow: View {
    let group: ToneGroup

    var body: some View {
        HStack(spacing: DesignSystem.Dimensions.paddingStandard) {
            // Tone icon
            Image(systemName: group.icon)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(DesignSystem.Colors.primary)
                .frame(width: 56, height: 56)
                .background(
                    RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadiusSmall)
                        .fill(DesignSystem.Colors.primary.opacity(0.1))
                )

            // Text
            VStack(alignment: .leading, spacing: 4) {
                Text(group.title)
                    .font(DesignSystem.Typography.headline)
                    .foregroundColor(DesignSystem.Colors.textPrimary)

                Text(group.description)
                    .font(DesignSystem.Typography.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .lineLimit(2)
            }

            Spacer()

            // Character count badge
            Text("\(group.targets.count)")
                .font(DesignSystem.Typography.subheadlineBold)
                .foregroundColor(DesignSystem.Colors.primary)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(DesignSystem.Colors.primary.opacity(0.1))
                )

            Image(systemName: "chevron.right")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(DesignSystem.Colors.textSecondary)
        }
        .padding(DesignSystem.Dimensions.paddingStandard)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(DesignSystem.Dimensions.cornerRadius)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Tone Group Detail (list of characters in a tone)

struct ToneGroupDetailView: View {
    let group: ToneGroup

    var body: some View {
        ScrollView {
            LazyVStack(spacing: DesignSystem.Dimensions.paddingSmall) {
                ForEach(Array(group.targets.enumerated()), id: \.element.id) { index, target in
                    NavigationLink(value: TonePracticeRoute(group: group, startIndex: index)) {
                        ToneCharacterRow(target: target)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(DesignSystem.Dimensions.paddingStandard)
        }
        .navigationTitle(group.title)
        .navigationBarTitleDisplayMode(.inline)
        .background(DesignSystem.Colors.background.ignoresSafeArea())
        .navigationDestination(for: TonePracticeRoute.self) { route in
            TonePracticeView(targets: route.group.targets, startIndex: route.startIndex)
        }
    }
}

// MARK: - Tone Character Row

struct ToneCharacterRow: View {
    let target: HanziTarget

    var body: some View {
        HStack(spacing: DesignSystem.Dimensions.paddingStandard) {
            // Hanzi character
            Text(target.character)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .frame(width: 60, height: 60)
                .background(
                    RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadiusSmall)
                        .fill(DesignSystem.Colors.primary.opacity(0.06))
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(target.pinyin)
                    .font(DesignSystem.Typography.headline)
                    .foregroundColor(DesignSystem.Colors.primary)

                if let tone = target.toneNumber {
                    Text("Tone \(tone)")
                        .font(DesignSystem.Typography.caption)
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                }
            }

            Spacer()

            Image(systemName: "mic.circle.fill")
                .font(.title2)
                .foregroundColor(DesignSystem.Colors.primary.opacity(0.5))
        }
        .padding(DesignSystem.Dimensions.paddingStandard)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(DesignSystem.Dimensions.cornerRadius)
        .shadow(color: Color.black.opacity(0.03), radius: 3, x: 0, y: 1)
    }
}

// MARK: - Navigation Route

struct TonePracticeRoute: Hashable {
    let group: ToneGroup
    let startIndex: Int
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ToneListView()
            .environmentObject(NavigationRouter())
    }
}
