import Combine
import SwiftUI

struct LearningDialogView: View {
    let dialogLines: [DialogLine]
    let onPlayAudio: () -> Void
    let isPlaying: Bool

    public var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Dialog")
                    .font(DesignSystem.Typography.headline)
                    .foregroundColor(DesignSystem.Colors.primary)
                Spacer()
            }
            .padding(.horizontal)

            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(0..<dialogLines.count, id: \.self) { index in
                        let line = dialogLines[index]
                        
                        HStack {
                            if line.speaker == "B" { Spacer() }
                            
                            VStack(alignment: line.speaker == "A" ? .leading : .trailing, spacing: 4) {
                                Text(line.speaker)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(DesignSystem.Colors.textSecondary)
                                
                                Text(line.text)
                                    .font(DesignSystem.Typography.headline)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .foregroundColor(.white)
                                    .background(
                                        line.speaker == "A"
                                        ? DesignSystem.Colors.secondary
                                        : DesignSystem.Colors.primary
                                    )
                                    .clipShape(.rect(cornerRadius: 12))
                            }
                            
                            if line.speaker == "A" { Spacer() }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .background(DesignSystem.Colors.cardBackground)
            .clipShape(.rect(cornerRadius: DesignSystem.Dimensions.cornerRadius))
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)

            Button(action: onPlayAudio) {
                HStack {
                    Image(systemName: isPlaying ? "stop.fill" : "speaker.wave.2.fill")
                    Text(isPlaying ? "Hentikan Audio" : "Putar Audio Dialog")
                }
                .font(DesignSystem.Typography.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isPlaying ? DesignSystem.Colors.primaryDark : DesignSystem.Colors.primary)
                .clipShape(.rect(cornerRadius: DesignSystem.Dimensions.cornerRadius))
            }
            .animation(.default, value: isPlaying)
        }
    }
}

#Preview {
    LearningDialogView(
        dialogLines: [
            DialogLine(speaker: "A", text: "你好！"),
            DialogLine(speaker: "B", text: "你好！你叫什么名字？"),
            DialogLine(speaker: "A", text: "我叫王明。"),
            DialogLine(speaker: "B", text: "我叫李娜。")
        ],
        onPlayAudio: {
            print("Tombol audio ditekan")
        },
        isPlaying: true
    )
    .padding()
}
