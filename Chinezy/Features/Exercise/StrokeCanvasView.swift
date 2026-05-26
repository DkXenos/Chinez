import SwiftUI
import PencilKit

struct BoundsPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

struct StrokeCanvasView: View {
    @StateObject private var validator: StrokeValidator
    @State private var canvasBounds: CGRect = .zero
    let onCharacterFinished: () -> Void
    let onMistake: () -> Void

    /// Called after each correct stroke with the 0-based stroke index.
    /// The parent uses this to trigger the Hanzi Writer animation.
    let onCorrectStroke: (Int) -> Void

    init(
        character: String,
        onCharacterFinished: @escaping () -> Void,
        onMistake: @escaping () -> Void,
        onCorrectStroke: @escaping (Int) -> Void
    ) {
        _validator = StateObject(wrappedValue: StrokeValidator(character: character))
        self.onCharacterFinished = onCharacterFinished
        self.onMistake = onMistake
        self.onCorrectStroke = onCorrectStroke
    }

    var body: some View {
        ZStack {
            PencilKitRepresentable(
                validator: validator,
                onCharacterFinished: onCharacterFinished,
                onMistake: onMistake,
                onCorrectStroke: onCorrectStroke
            )
            .background(
                GeometryReader { geo in
                    Color.clear
                        .preference(key: BoundsPreferenceKey.self, value: geo.frame(in: .local))
                }
            )
            .onPreferenceChange(BoundsPreferenceKey.self) { bounds in
                canvasBounds = bounds
                validator.updateExpectedPoints(for: bounds)
            }
        }
    }
}

struct PencilKitRepresentable: UIViewRepresentable {
    @ObservedObject var validator: StrokeValidator
    let onCharacterFinished: () -> Void
    let onMistake: () -> Void
    let onCorrectStroke: (Int) -> Void

    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        canvas.drawingPolicy = .anyInput
        canvas.backgroundColor = .clear
        canvas.isOpaque = false
        canvas.delegate = context.coordinator

        // Use a thin ink for stroke input
        canvas.tool = PKInkingTool(.pen, color: .systemGray3, width: 8)

        return canvas
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(
            self,
            validator: validator,
            onCharacterFinished: onCharacterFinished,
            onMistake: onMistake,
            onCorrectStroke: onCorrectStroke
        )
    }

    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: PencilKitRepresentable
        var validator: StrokeValidator
        let onCharacterFinished: () -> Void
        let onMistake: () -> Void
        let onCorrectStroke: (Int) -> Void

        init(
            _ parent: PencilKitRepresentable,
            validator: StrokeValidator,
            onCharacterFinished: @escaping () -> Void,
            onMistake: @escaping () -> Void,
            onCorrectStroke: @escaping (Int) -> Void
        ) {
            self.parent = parent
            self.validator = validator
            self.onCharacterFinished = onCharacterFinished
            self.onMistake = onMistake
            self.onCorrectStroke = onCorrectStroke
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            guard !canvasView.drawing.strokes.isEmpty else { return }
            let currentStrokesCount = canvasView.drawing.strokes.count

            if currentStrokesCount <= validator.currentStrokeIndex {
                return
            }

            guard let latestStroke = canvasView.drawing.strokes.last else { return }

            // The stroke index BEFORE validation (0-based)
            let strokeIndex = validator.currentStrokeIndex

            let isValid = validator.validateStroke(latestStroke, canvasBounds: canvasView.bounds)

            if !isValid {
                // ── Wrong stroke ────────────────────────────────────
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)

                DispatchQueue.main.async {
                    canvasView.undoManager?.undo()
                }

                onMistake()
            } else {
                // ── Correct stroke ──────────────────────────────────
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()

                // Notify parent so it can trigger the Hanzi Writer
                // animation for this stroke index
                onCorrectStroke(strokeIndex)

                // Clear the user's PK drawing — Hanzi Writer will
                // render the proper animated stroke underneath
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    canvasView.drawing = PKDrawing()
                }

                if validator.isFinished {
                    let successGenerator = UINotificationFeedbackGenerator()
                    successGenerator.notificationOccurred(.success)
                    onCharacterFinished()
                }
            }
        }
    }
}

