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
    
    init(character: String, onCharacterFinished: @escaping () -> Void, onMistake: @escaping () -> Void) {
        _validator = StateObject(wrappedValue: StrokeValidator(character: character))
        self.onCharacterFinished = onCharacterFinished
        self.onMistake = onMistake
    }
    
    var body: some View {
        ZStack {
            PencilKitRepresentable(validator: validator, onCharacterFinished: onCharacterFinished, onMistake: onMistake)
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
            
            if let start = validator.expectedStartOnScreen, let end = validator.expectedEndOnScreen {
                Circle()
                    .fill(Color.green)
                    .frame(width: 15, height: 15)
                    .position(start)
                
                Circle()
                    .fill(Color.red)
                    .frame(width: 15, height: 15)
                    .position(end)
            }
        }
    }
}

struct PencilKitRepresentable: UIViewRepresentable {
    @ObservedObject var validator: StrokeValidator
    let onCharacterFinished: () -> Void
    let onMistake: () -> Void
    
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
        Coordinator(self, validator: validator, onCharacterFinished: onCharacterFinished, onMistake: onMistake)
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: PencilKitRepresentable
        var validator: StrokeValidator
        let onCharacterFinished: () -> Void
        let onMistake: () -> Void
        
        init(_ parent: PencilKitRepresentable, validator: StrokeValidator, onCharacterFinished: @escaping () -> Void, onMistake: @escaping () -> Void) {
            self.parent = parent
            self.validator = validator
            self.onCharacterFinished = onCharacterFinished
            self.onMistake = onMistake
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            guard !canvasView.drawing.strokes.isEmpty else { return }
            let currentStrokesCount = canvasView.drawing.strokes.count
            
            if currentStrokesCount <= validator.currentStrokeIndex {
                return
            }
            
            guard let latestStroke = canvasView.drawing.strokes.last else { return }
            
            let isValid = validator.validateStroke(latestStroke, canvasBounds: canvasView.bounds)
            
            if !isValid {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
                
                DispatchQueue.main.async {
                    canvasView.undoManager?.undo()
                }
                
                onMistake()
            } else {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                
                if validator.isFinished {
                    let successGenerator = UINotificationFeedbackGenerator()
                    successGenerator.notificationOccurred(.success)
                    onCharacterFinished()
                }
            }
        }
    }
}
