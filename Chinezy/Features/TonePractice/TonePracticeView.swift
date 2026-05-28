import SwiftUI

// MARK: – Data Model

struct ToneTarget {
    let hanzi: String
    let pinyin: String
    let tone: String
    let toneNumber: Int
}

// MARK: – Main View

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
            // ── Background ──────────────────────────────────
            LinearGradient(
                colors: [
                    Color(red: 0.06, green: 0.07, blue: 0.14),
                    Color(red: 0.10, green: 0.11, blue: 0.22)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {

                // ── Header ──────────────────────────────────
                headerSection
                    .padding(.top, 8)

                Spacer()

                // ── Character Card ──────────────────────────
                characterCard
                    .padding(.horizontal, DesignSystem.Dimensions.paddingLarge)

                Spacer()

                // ── Feedback (only in .result) ──────────────
                if toneService.state == .result {
                    feedbackBadge
                        .transition(.scale.combined(with: .opacity))
                        .padding(.bottom, 20)
                }

                // ── Action Area ─────────────────────────────
                actionArea
                    .padding(.bottom, 12)

                // ── Hint ────────────────────────────────────
                Text(hintText)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.4))
                    .padding(.bottom, DesignSystem.Dimensions.paddingLarge)
            }
        }
        .navigationTitle("Tone Practice")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Color.clear, for: .navigationBar)
        .onAppear { toneService.requestMicrophonePermission() }
        .animation(.easeInOut(duration: 0.3), value: toneService.state)
        .alert("Error", isPresented: .constant(toneService.errorMessage != nil)) {
            Button("OK") { toneService.errorMessage = nil }
        } message: {
            Text(toneService.errorMessage ?? "")
        }
    }

    // MARK: – Header

    private var headerSection: some View {
        VStack(spacing: 4) {
            Text("Pronounce the character")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.5))

            HStack(spacing: 6) {
                Image(systemName: "target")
                    .font(.system(size: 14, weight: .semibold))
                Text("Target: Tone \(target.toneNumber)")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
            }
            .foregroundColor(accentColor)
        }
    }

    // MARK: – Character Card

    private var characterCard: some View {
        VStack(spacing: 16) {
            Text(target.hanzi)
                .font(.system(size: 120, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: accentColor.opacity(0.35), radius: 24, x: 0, y: 8)

            Text(target.pinyin)
                .font(.system(size: 28, weight: .semibold, design: .rounded))
                .foregroundColor(.white.opacity(0.65))

            // Waveform bars
            waveformView
                .frame(height: 32)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 36)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.ultraThinMaterial.opacity(0.35))
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .strokeBorder(
                            LinearGradient(
                                colors: [.white.opacity(0.15), .white.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .environment(\.colorScheme, .dark)
    }

    private var waveformView: some View {
        HStack(spacing: 3) {
            ForEach(0..<20, id: \.self) { i in
                let isActive = toneService.state == .recording
                RoundedRectangle(cornerRadius: 2)
                    .fill(accentColor.opacity(isActive ? 0.8 : 0.3))
                    .frame(
                        width: 3,
                        height: isActive ? waveHeight(for: i) : 6
                    )
                    .animation(
                        isActive
                            ? .easeInOut(duration: 0.4)
                                .repeatForever(autoreverses: true)
                                .delay(Double(i) * 0.05)
                            : .easeOut(duration: 0.3),
                        value: isActive
                    )
            }
        }
    }

    private func waveHeight(for index: Int) -> CGFloat {
        let n = Double(index) / 20.0
        return CGFloat(8 + 18 * abs(sin(n * .pi * 2)))
    }

    // MARK: – Feedback Badge (shown only in .result)

    private var feedbackBadge: some View {
        let verdict = evaluateResult()
        return HStack(spacing: 8) {
            Image(systemName: verdict.icon)
                .font(.system(size: 16, weight: .semibold))
            Text(verdict.text)
                .font(.system(size: 17, weight: .bold, design: .rounded))
        }
        .foregroundColor(verdict.color)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(verdict.color.opacity(0.12))
                .overlay(
                    Capsule()
                        .strokeBorder(verdict.color.opacity(0.25), lineWidth: 1)
                )
        )
    }

    // MARK: – Action Area (button or spinner)

    @ViewBuilder
    private var actionArea: some View {
        switch toneService.state {
        case .idle, .result:
            micButton(isRecording: false)
        case .recording:
            micButton(isRecording: true)
        case .analyzing:
            VStack(spacing: 10) {
                ProgressView()
                    .controlSize(.large)
                    .tint(.white)
                Text("Analyzing…")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.6))
            }
            .frame(height: 100)
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
            ZStack {
                // Outer pulse ring
                if isRecording {
                    Circle()
                        .fill(Color.red.opacity(0.15))
                        .frame(width: 100, height: 100)
                        .scaleEffect(isPulsing ? 1.3 : 1.0)
                        .opacity(isPulsing ? 0.0 : 0.6)
                        .animation(
                            .easeOut(duration: 1.0)
                                .repeatForever(autoreverses: false),
                            value: isPulsing
                        )
                }

                // Circle
                Circle()
                    .fill(
                        isRecording
                            ? LinearGradient(
                                colors: [Color.red, Color.red.opacity(0.7)],
                                startPoint: .top, endPoint: .bottom
                              )
                            : LinearGradient(
                                colors: [accentColor, accentColor.opacity(0.7)],
                                startPoint: .top, endPoint: .bottom
                              )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(
                        color: (isRecording ? Color.red : accentColor).opacity(0.5),
                        radius: 16, x: 0, y: 6
                    )

                // Icon
                Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.impact(weight: .medium), trigger: toneService.state)
    }

    // MARK: – Hint Text

    private var hintText: String {
        switch toneService.state {
        case .idle:      return "Tap to start recording"
        case .recording: return "Listening… Tap to stop"
        case .analyzing: return "Processing your pronunciation"
        case .result:    return "Tap to try again"
        }
    }

    // MARK: – Verdict Logic

    private struct Verdict {
        let text: String
        let icon: String
        let color: Color
    }

    private func evaluateResult() -> Verdict {
        let predicted = toneService.predictedTone

        if predicted == "Unclear / Too Noisy" {
            return Verdict(
                text: "Unclear — try again in a quieter place",
                icon: "exclamationmark.triangle.fill",
                color: .yellow
            )
        } else if predicted == target.tone {
            return Verdict(
                text: "Correct!  \(displayTone(predicted))",
                icon: "checkmark.circle.fill",
                color: .green
            )
        } else {
            return Verdict(
                text: "Detected \(displayTone(predicted)) — expected Tone \(target.toneNumber)",
                icon: "xmark.circle.fill",
                color: Color(red: 1.0, green: 0.35, blue: 0.37)
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

    // MARK: – Accent Color

    private var accentColor: Color {
        switch target.toneNumber {
        case 1:  return Color(red: 0.30, green: 0.70, blue: 1.0)
        case 2:  return Color(red: 0.45, green: 0.85, blue: 0.50)
        case 3:  return Color(red: 0.95, green: 0.65, blue: 0.20)
        case 4:  return Color(red: 0.95, green: 0.35, blue: 0.40)
        default: return DesignSystem.Colors.primary
        }
    }
}

// MARK: – Preview

#Preview {
    NavigationStack {
        TonePracticeView()
    }
    .environmentObject(NavigationRouter())
}
