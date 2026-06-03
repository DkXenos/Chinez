import Combine
import SwiftUI

struct ExerciseContainerView: View {
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var viewModel = ExerciseViewModel()
    let part: Part

    /// Drives the HanziWebView binding — kept in sync with the viewModel.
    @State private var quizCharacter: String = ""

    /// Brief checkmark overlay shown between characters.
    @State private var showStrokeSuccess: Bool = false

    /// Reference to the HanziWebView's coordinator so we can call
    /// `animateStroke(at:)` from the native drawing layer.
    @State private var hanziCoordinator: HanziWebView.Coordinator?
    
    /// Tracks if the character is fully loaded in the WebView.
    @State private var isLoaded: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isQuizComplete {
                    // ── Completion Screen ────────────────────────────
                    VStack(spacing: DesignSystem.Dimensions.paddingLarge) {
                        Text("Level Complete!")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(DesignSystem.Colors.textPrimary)

                        Text("Total Mistakes: \(viewModel.mistakeCount)")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(DesignSystem.Colors.textSecondary)

                        PrimaryButton(title: "Return to Course", systemImage: "checkmark.circle.fill") {
                            router.showExercise = false
                        }
                        .padding(.horizontal, DesignSystem.Dimensions.paddingLarge)
                        .padding(.top, DesignSystem.Dimensions.paddingLarge)
                    }
                } else {
                    // ── Active Quiz Screen ──────────────────────────
                    VStack(spacing: DesignSystem.Dimensions.paddingStandard) {
                        // Progress counter
                        Text("\(viewModel.currentIndex + 1) / \(viewModel.charactersToLearn.count)")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                            .padding(.top, DesignSystem.Dimensions.paddingLarge)

                        // Large target character
                        Text(viewModel.currentCharacter)
                            .font(.system(size: 120, weight: .bold))
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                            .padding(.top, DesignSystem.Dimensions.paddingStandard)

                        Spacer()

                        // ── Layered Canvas ──────────────────────────
                        // Bottom: HanziWebView (animated stroke renderer, no touch)
                        // Top:    StrokeCanvasView (PencilKit touch input)
                        ZStack {
                            // Background card
                            RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadius, style: .continuous)
                                .fill(DesignSystem.Colors.secondaryBackground)

                            // Layer 1: Hanzi Writer — renders animated strokes
                            // User interaction is disabled inside the view itself.
                            HanziWebView(
                                character: $quizCharacter,
                                onAllStrokesCompleted: nil,
                                onCoordinatorReady: { coordinator in
                                    hanziCoordinator = coordinator
                                },
                                onLoaded: {
                                    withAnimation(.easeInOut) {
                                        isLoaded = true
                                    }
                                }
                            )

                            // Layer 2: PencilKit — user draws strokes here
                            StrokeCanvasView(
                                character: viewModel.currentCharacter,
                                onCharacterFinished: {
                                    handleCharacterFinished()
                                },
                                onMistake: {
                                    viewModel.registerMistake()
                                },
                                onCorrectStroke: { strokeIndex in
                                    // Tell Hanzi Writer to animate this stroke
                                    hanziCoordinator?.animateStroke(at: strokeIndex)
                                }
                            )
                            .id(viewModel.currentCharacter)

                            if !isLoaded {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .scaleEffect(1.5)
                                    .transition(.opacity)
                            }

                            // Success overlay between characters
                            if showStrokeSuccess {
                                VStack(spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 56))
                                        .foregroundColor(Color(red: 0.2, green: 0.78, blue: 0.35))
                                    Text("Correct!")
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                        .foregroundColor(DesignSystem.Colors.textPrimary)
                                }
                                .transition(.scale.combined(with: .opacity))
                                .allowsHitTesting(false)
                            }
                        }
                        .aspectRatio(1, contentMode: .fit)
                        .clipShape(
                            RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadius, style: .continuous)
                        )
                        .padding(.horizontal, DesignSystem.Dimensions.paddingLarge)

                        Spacer()

                        // Mistake counter (only shown if > 0)
                        if viewModel.mistakeCount > 0 {
                            Text("Mistakes: \(viewModel.mistakeCount)")
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                                .padding(.bottom, DesignSystem.Dimensions.paddingStandard)
                        }
                    }
                }
            }
            .navigationTitle(part.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        router.showExercise = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                    }
                }
            }
            .background(DesignSystem.Colors.background.ignoresSafeArea())
            .onAppear {
                quizCharacter = viewModel.currentCharacter
            }
            .onChange(of: viewModel.currentIndex) { _ in
                isLoaded = false
                quizCharacter = viewModel.currentCharacter
            }
        }
    }

    // MARK: – Handlers

    /// Called when the user completes all strokes for the current character.
    private func handleCharacterFinished() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)

        print("✅ Character completed: \(viewModel.currentCharacter)")

        // Show the success overlay briefly
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            showStrokeSuccess = true
        }

        // Advance to the next character after a short celebration
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation {
                showStrokeSuccess = false
            }
            viewModel.characterCompleted()
        }
    }
}

