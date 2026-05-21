import SwiftUI
import PencilKit

struct StrokeCanvasView: UIViewRepresentable {
    @StateObject private var validator: StrokeValidator
    
    init(character: String) {
        _validator = StateObject(wrappedValue: StrokeValidator(character: character))
    }
    
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
        Coordinator(self, validator: validator)
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: StrokeCanvasView
        var validator: StrokeValidator
        
        init(_ parent: StrokeCanvasView, validator: StrokeValidator) {
            self.parent = parent
            self.validator = validator
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
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
            } else {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                
                if validator.isFinished {
                    let successGenerator = UINotificationFeedbackGenerator()
                    successGenerator.notificationOccurred(.success)
                }
            }
        }
    }
}
