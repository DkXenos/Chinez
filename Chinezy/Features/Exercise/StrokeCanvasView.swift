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
        return canvas
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self, validator: validator,
                    onCharacterFinished: onCharacterFinished,
                    onMistake: onMistake,
                    onCorrectStroke: onCorrectStroke)
    }

    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: PencilKitRepresentable
        var validator: StrokeValidator
        let onCharacterFinished: () -> Void
        let onMistake: () -> Void
        let onCorrectStroke: (Int) -> Void

        /// Tracks the last canvas stroke count we saw, so we only react
        /// to *new* strokes being added (not undos reducing the count).
        /// This replaces the old guard that compared against
        /// `validator.currentStrokeIndex` — which broke after undoing
        /// correct strokes because the validator index kept incrementing
        /// while the canvas count reset.
        var lastSeenStrokeCount: Int = 0

        init(_ parent: PencilKitRepresentable, validator: StrokeValidator,
             onCharacterFinished: @escaping () -> Void,
             onMistake: @escaping () -> Void,
             onCorrectStroke: @escaping (Int) -> Void) {
            self.parent = parent
            self.validator = validator
            self.onCharacterFinished = onCharacterFinished
            self.onMistake = onMistake
            self.onCorrectStroke = onCorrectStroke
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            let count = canvasView.drawing.strokes.count

            // Only process when a NEW stroke is added.
            // Undo calls (which decrease the count) are ignored.
            guard count > lastSeenStrokeCount else {
                lastSeenStrokeCount = count
                return
            }
            lastSeenStrokeCount = count

            guard let latestStroke = canvasView.drawing.strokes.last else { return }

            let strokeIndex = validator.currentStrokeIndex
            let isValid = validator.validateStroke(latestStroke, canvasBounds: canvasView.bounds)

            if !isValid {
                // Wrong stroke — undo it, canvas stays clean
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)

                DispatchQueue.main.async {
                    canvasView.undoManager?.undo()
                }

                onMistake()
            } else {
                // Correct stroke — trigger Hanzi Writer animation, then
                // undo the PK ink so the canvas stays clean (the Hanzi
                // Writer layer underneath renders the proper stroke).
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()

                onCorrectStroke(strokeIndex)

                DispatchQueue.main.async {
                    canvasView.undoManager?.undo()
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
