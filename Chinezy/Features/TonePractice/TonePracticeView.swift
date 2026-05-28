import SwiftUI

// MARK: - Data Model

struct ToneTarget {
    let hanzi: String
    let pinyin: String
    let tone: String
    let toneNumber: Int
}

// MARK: - Main View

struct TonePracticeView: View {
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var toneService = ToneEvaluatorService()

    private let target = ToneTarget(
        hanzi: "妈",
        pinyin: "mā",
        tone: "Tone_1",
        toneNumber: 1
    )

    /// Pulsing animation driver for the recording state.
    @State private var isPulsing = false

    var body: some View {
        ZStack {
            // Background
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 24) {

                Spacer()

                // Character Card
                characterCard
                    .padding(.horizontal, 24)

                Spacer()

                // Feedback (only in .result)
                if toneService.state == .result {
                    feedbackBadge
                        .transition(.scale.combined(with: .opacity))
                        .padding(.bottom, 8)
                } else if toneService.state == .recording {
                    listeningBadge
                        .transition(.scale.combined(with: .opacity))
                        .padding(.bottom, 8)
                } else {
                    // Placeholder to maintain spacing
                    Color.clear
                        .frame(height: 40)
                        .padding(.bottom, 8)
                }

                // Action Area
                actionArea
                    .padding(.bottom, 16)

                // Hint
                Text(hintText)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 32)
            }
        }
        .navigationTitle("Tone Practice")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { toneService.requestMicrophonePermission() }
        .animation(.easeInOut(duration: 0.3), value: toneService.state)
        .alert("Error", isPresented: .constant(toneService.errorMessage != nil)) {
            Button("OK") { toneService.errorMessage = nil }
        } message: {
            Text(toneService.errorMessage ?? "")
        }
    }

    // MARK: - Character Card

    private var characterCard: some View {
        VStack(spacing: 12) {
            Text("Target: Tone \(target.toneNumber)")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .padding(.top, 24)

            Text(target.hanzi)
                .font(.system(size: 140, weight: .bold))
                .foregroundColor(.primary)

            Text(target.pinyin)
                .font(.system(size: 32, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
                .padding(.bottom, 32)
        }
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }

    // MARK: - Badges

    private var listeningBadge: some View {
        HStack(spacing: 6) {
            Image(systemName: "ear")
                .font(.system(size: 14, weight: .semibold))
            Text("Listening...")
                .font(.system(size: 15, weight: .semibold))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Capsule().fill(Color.blue))
    }

    private var feedbackBadge: some View {
        let verdict = evaluateResult()
        return HStack(spacing: 6) {
            Image(systemName: verdict.icon)
                .font(.system(size: 14, weight: .semibold))
            Text(verdict.text)
                .font(.system(size: 15, weight: .semibold))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Capsule().fill(verdict.color))
    }

    // MARK: - Action Area

    @ViewBuilder
    private var actionArea: some View {
        switch toneService.state {
        case .idle, .result:
            micButton(isRecording: false)
        case .recording:
            micButton(isRecording: true)
        case .analyzing:
            VStack(spacing: 12) {
                ProgressView()
                    .controlSize(.large)
                Text("Analyzing...")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .frame(height: 88)
        }
    }

    private func micButton(isRecording: Bool) -> some View {
        Button {
            if isRecording {
                toneService.stopAndEvaluate()
                isPulsing = false
            } else {
                toneService.startRecording()
                isPulsing = true
            }
        } label: {
            Image(systemName: isRecording ? "stop.circle.fill" : "mic.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 88, height: 88)
                .foregroundColor(isRecording ? .red : .blue)
                .symbolEffect(.bounce, value: toneService.state)
                .scaleEffect(isPulsing ? 1.05 : 1.0)
                .animation(
                    isRecording
                        ? .easeInOut(duration: 0.8).repeatForever(autoreverses: true)
                        : .default,
                    value: isPulsing
                )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Hint Text

    private var hintText: String {
        switch toneService.state {
        case .idle:      return "Tap to start recording"
        case .recording: return "Tap to stop"
        case .analyzing: return "Please wait"
        case .result:    return "Tap to try again"
        }
    }

    // MARK: - Verdict Logic

    private struct Verdict {
        let text: String
        let icon: String
        let color: Color
    }

    private func evaluateResult() -> Verdict {
        let predicted = toneService.predictedTone

        if predicted == "Noise detected. Please try again." {
            return Verdict(
                text: "Unclear / Too Noisy",
                icon: "exclamationmark.triangle.fill",
                color: .orange
            )
        } else if predicted == target.tone {
            return Verdict(
                text: "Correct! \(displayTone(predicted))",
                icon: "checkmark.circle.fill",
                color: .green
            )
        } else {
            return Verdict(
                text: "Detected \(displayTone(predicted)) - expected Tone \(target.toneNumber)",
                icon: "xmark.circle.fill",
                color: .red
            )
        }
    }

    private func displayTone(_ raw: String) -> String {
        switch raw {
        case "Tone_1": return "Tone 1 (flat)"
        case "Tone_2": return "Tone 2 (rising)"
        case "Tone_3": return "Tone 3 (dipping)"
        case "Tone_4": return "Tone 4 (falling)"
        default:       return raw
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        TonePracticeView()
    }
    .environmentObject(NavigationRouter())
}
