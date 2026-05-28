import SwiftUI

// MARK: - Main View

struct TonePracticeView: View {
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var toneService = ToneEvaluatorService()

    /// All targets the user can swipe through.
    private let targets = HanziTarget.defaults

    /// Index of the currently selected Hanzi target.
    @State private var selectedIndex: Int = 0

    /// Pulsing animation driver for the recording state.
    @State private var isPulsing = false

    /// The currently selected target, derived from the index.
    private var currentTarget: HanziTarget {
        targets[selectedIndex]
    }

    var body: some View {
        ZStack {
            // Background
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {

                // ── Top: Carousel ────────────────────────────
                targetCarousel
                    .padding(.top, 16)

                // ── Page Indicator ───────────────────────────
                pageIndicator
                    .padding(.top, 12)

                Spacer()

                // ── Feedback Area ────────────────────────────
                feedbackArea
                    .frame(minHeight: 52)
                    .padding(.horizontal, 24)

                Spacer()

                // ── Microphone Button ────────────────────────
                actionArea
                    .padding(.bottom, 8)

                // ── Hint ─────────────────────────────────────
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

    // MARK: - Carousel

    private var targetCarousel: some View {
        TabView(selection: $selectedIndex) {
            ForEach(Array(targets.enumerated()), id: \.element.id) { index, target in
                HanziCard(target: target)
                    .padding(.horizontal, 24)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 360)
        .onChange(of: selectedIndex) { _, _ in
            // Reset evaluator when the user swipes to a new target
            withAnimation(.easeOut(duration: 0.2)) {
                toneService.reset()
                isPulsing = false
            }
        }
    }

    // MARK: - Page Indicator

    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<targets.count, id: \.self) { index in
                Capsule()
                    .fill(index == selectedIndex ? Color.accentColor : Color.secondary.opacity(0.25))
                    .frame(width: index == selectedIndex ? 24 : 8, height: 8)
                    .animation(.spring(response: 0.35, dampingFraction: 0.7), value: selectedIndex)
            }
        }
    }

    // MARK: - Feedback Area

    @ViewBuilder
    private var feedbackArea: some View {
        switch toneService.state {
        case .result:
            feedbackBadge
                .transition(.scale.combined(with: .opacity))
        case .recording:
            listeningBadge
                .transition(.scale.combined(with: .opacity))
        case .analyzing:
            HStack(spacing: 8) {
                ProgressView()
                    .controlSize(.small)
                Text("Analyzing…")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .transition(.scale.combined(with: .opacity))
        case .idle:
            Color.clear.frame(height: 40)
        }
    }

    // MARK: - Badges

    private var listeningBadge: some View {
        HStack(spacing: 6) {
            Image(systemName: "ear")
                .font(.system(size: 14, weight: .semibold))
            Text("Listening…")
                .font(.system(size: 15, weight: .semibold))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Capsule().fill(Color.blue))
    }

    private var feedbackBadge: some View {
        let verdict = evaluateResult()
        return HStack(spacing: 8) {
            Image(systemName: verdict.icon)
                .font(.system(size: 16, weight: .semibold))
            Text(verdict.text)
                .font(.system(size: 15, weight: .semibold))
        }
        .foregroundColor(verdict.color)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(verdict.color.opacity(0.12))
        )
        .overlay(
            Capsule()
                .strokeBorder(verdict.color.opacity(0.25), lineWidth: 1)
        )
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
            // The analyzing state is shown in feedbackArea, keep mic area stable
            Color.clear.frame(width: 88, height: 88)
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
                // Outer pulse ring (recording only)
                if isRecording {
                    Circle()
                        .stroke(Color.red.opacity(0.25), lineWidth: 4)
                        .frame(width: 100, height: 100)
                        .scaleEffect(isPulsing ? 1.2 : 1.0)
                        .opacity(isPulsing ? 0.0 : 0.6)
                        .animation(
                            .easeOut(duration: 1.2).repeatForever(autoreverses: false),
                            value: isPulsing
                        )
                }

                Image(systemName: isRecording ? "stop.circle.fill" : "mic.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 88, height: 88)
                    .foregroundColor(isRecording ? .red : .blue)
                    .symbolEffect(.bounce, value: toneService.state)
                    .scaleEffect(isPulsing ? 1.06 : 1.0)
                    .animation(
                        isRecording
                            ? .easeInOut(duration: 0.8).repeatForever(autoreverses: true)
                            : .default,
                        value: isPulsing
                    )
            }
            .frame(width: 110, height: 110) // Fixed frame to contain pulse
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
        } else if predicted == currentTarget.targetTone {
            return Verdict(
                text: "Correct! \(displayTone(predicted))",
                icon: "checkmark.circle.fill",
                color: .green
            )
        } else {
            let expectedNum = currentTarget.toneNumber.map { String($0) } ?? "?"
            return Verdict(
                text: "Detected \(displayTone(predicted)) — expected Tone \(expectedNum)",
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

// MARK: - Hanzi Card

/// A premium, Apple-HIG–inspired card showing a single Hanzi target.
private struct HanziCard: View {
    let target: HanziTarget

    var body: some View {
        VStack(spacing: 12) {
            // Tone label
            Text("Target: Tone \(target.toneNumber.map { String($0) } ?? "?")")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .padding(.top, 28)

            Spacer(minLength: 0)

            // Hanzi character
            Text(target.character)
                .font(.system(size: 140, weight: .bold))
                .foregroundColor(.primary)
                .minimumScaleFactor(0.6)

            // Pinyin
            Text(target.pinyin)
                .font(.system(size: 32, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)

            Spacer(minLength: 0)

            // Subtle bottom padding
            Color.clear.frame(height: 28)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 16, x: 0, y: 6)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        TonePracticeView()
    }
    .environmentObject(NavigationRouter())
}
