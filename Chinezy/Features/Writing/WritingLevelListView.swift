
import SwiftUI
import Combine

struct WritingLevelListView: View {
    @StateObject private var viewModel = WritingLevelListViewModel()

    var body: some View {
        content
            .navigationTitle("Writing")
            .navigationDestination(for: WritingLevel.self) { level in
                WritingQuizView(level: level)
            }
            .tint(DesignSystem.Colors.primary)
    }

    @ViewBuilder
    private var content: some View {
        if let error = viewModel.errorMessage {
            errorView(message: error)
        } else {
            ScrollView {
                LazyVStack(spacing: DesignSystem.Dimensions.paddingSmall) {
                    ForEach(viewModel.levels) { level in
                        NavigationLink(value: level) {
                            WritingLevelRow(level: level)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, DesignSystem.Dimensions.paddingStandard)
                .padding(.top, 8)
                .padding(.bottom, DesignSystem.Dimensions.paddingLarge)
            }
            .background(DesignSystem.Colors.surfaceWhite)
        }
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: DesignSystem.Dimensions.paddingSmall) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundStyle(DesignSystem.Colors.primary)
            Text("Gagal Memuat Data")
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


private struct WritingLevelRow: View {
    let level: WritingLevel

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadiusMedium, style: .continuous)
                    .fill(DesignSystem.Colors.background)
                RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadiusMedium, style: .continuous)
                    .strokeBorder(DesignSystem.Colors.gold, lineWidth: 1.5)
                Text(level.characters.first ?? "字")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(DesignSystem.Colors.primary)
            }
            .frame(width: 54, height: 54)

            VStack(alignment: .leading, spacing: 4) {
                Text("LEVEL \(level.id)")
                    .font(.system(size: 10, weight: .heavy))
                    .tracking(1)
                    .foregroundStyle(DesignSystem.Colors.primaryDark)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 2)
                    .background(Capsule().fill(DesignSystem.Colors.goldLight.opacity(0.5)))

                Text(level.title)
                    .font(.headline)
                    .foregroundStyle(DesignSystem.Colors.textDark)

                Text("\(level.characterCount) karakter")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 8)

            Image(systemName: "chevron.right")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(DesignSystem.Colors.primary.opacity(0.45))
        }
        .padding(DesignSystem.Dimensions.cornerRadiusMedium)
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
    NavigationStack {
        WritingLevelListView()
    }
}
