import SwiftUI

struct LearningDialogView: View {
    let dialogText: String
    let onPlayAudio: () -> Void

    public init(dialogText: String, onPlayAudio: @escaping () -> Void) {
        self.dialogText = dialogText
        self.onPlayAudio = onPlayAudio
    }

    public var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Percakapan / Dialog")
                    .font(DesignSystem.Typography.headline)
                    .foregroundColor(DesignSystem.Colors.primary)
                Spacer()
            }
            .padding(.horizontal)

            ScrollView {
                Text(dialogText)
                    .font(DesignSystem.Typography.headline)
                    .lineSpacing(12)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(DesignSystem.Colors.cardBackground)
            .cornerRadius(DesignSystem.Dimensions.cornerRadius)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)

            Button(action: onPlayAudio) {
                HStack {
                    Image(systemName: "speaker.wave.2.fill")
                    Text("Putar Audio Dialog")
                }
                .font(DesignSystem.Typography.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(DesignSystem.Colors.primary)
                .cornerRadius(DesignSystem.Dimensions.cornerRadius)
            }
        }
    }
}
