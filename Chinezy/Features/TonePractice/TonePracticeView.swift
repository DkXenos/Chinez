import SwiftUI
import Combine

// MARK: - Main View

struct TonePracticeView: View {
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var viewModel = TonePracticeViewModel()

    /// Optional: pass specific targets and a starting index from ToneListView.
    var targets: [HanziTarget]?
    var startIndex: Int = 0

    var body: some View {
        ZStack {
            // Background
            DesignSystem.Colors.background
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
                    .padding(.bottom, 32)
            }
        }
        .navigationTitle("Tone Practice")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let targets = targets {
                viewModel.configure(targets: targets, startIndex: startIndex)
            }
            viewModel.requestMicrophonePermission()
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.serviceState)
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    // MARK: - Carousel

    private var targetCarousel: some View {
        TabView(selection: $viewModel.selectedIndex) {
            ForEach(Array(viewModel.targets.enumerated()), id: \.element.id) { index, target in
                HanziCard(target: target)
                    .padding(.horizontal, 24)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 360)
        // Resetting is now handled via didSet in ViewModel
    }

    // MARK: - Page Indicator

    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<viewModel.targets.count, id: \.self) { index in
                Capsule()
                    .fill(index == viewModel.selectedIndex ? Color.accentColor : Color.secondary.opacity(0.25))
                    .frame(width: index == viewModel.selectedIndex ? 24 : 8, height: 8)
                    .animation(.spring(response: 0.35, dampingFraction: 0.7), value: viewModel.selectedIndex)
            }
        }
    }

    // MARK: - Feedback Area

    @ViewBuilder
    private var feedbackArea: some View {
        switch viewModel.serviceState {
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
        .background(Capsule().fill(DesignSystem.Colors.primary))
    }

    private var feedbackBadge: some View {
        let verdict = viewModel.evaluateResult()
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
        switch viewModel.serviceState {
        case .idle, .result:
            micButton(isRecording: false)
        case .recording:
            micButton(isRecording: true)
        case .analyzing:
            Color.clear.frame(width: 88, height: 88)
        }
    }

    private func micButton(isRecording: Bool) -> some View {
        Button {
            if isRecording {
                viewModel.stopAndEvaluate()
            } else {
                viewModel.startRecording()
            }
        } label: {
            Image(systemName: isRecording ? "stop.circle.fill" : "mic.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 88, height: 88)
                .foregroundColor(isRecording ? DesignSystem.Colors.error : DesignSystem.Colors.primary)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Hanzi Card

private struct HanziCard: View {
    let target: HanziTarget

    var body: some View {
        VStack(spacing: 12) {
            Text("Target: Tone \(target.toneNumber.map { String($0) } ?? "?")")
                .font(DesignSystem.Typography.subheadlineBold)
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .padding(.top, 28)

            Spacer(minLength: 0)

            Text(target.character)
                .font(.system(size: 140, weight: .bold))
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .minimumScaleFactor(0.6)

            Text(target.pinyin)
                .font(.system(size: 32, weight: .medium, design: .rounded))
                .foregroundColor(DesignSystem.Colors.primary)

            Spacer(minLength: 0)

            Color.clear.frame(height: 28)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadius, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 16, x: 0, y: 6)
    }
}

#Preview {
    NavigationStack {
        TonePracticeView()
    }
    .environmentObject(NavigationRouter())
}
