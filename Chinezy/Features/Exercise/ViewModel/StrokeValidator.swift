import Foundation
import PencilKit
import Combine
import CoreGraphics

class StrokeValidator: ObservableObject {
    @Published var currentStrokeIndex: Int = 0
    @Published var isFinished: Bool = false
    
    @Published var expectedStartOnScreen: CGPoint? = nil
    @Published var expectedEndOnScreen: CGPoint? = nil
    
    let targetCharacter: String
    private var expectedStrokes: [[[Int]]] = []
    
    private let maxDistanceTolerance: CGFloat = 100.0
    
    init(character: String) {
        self.targetCharacter = character
        if let data = HanziDataManager.shared.dictionary[character] {
            self.expectedStrokes = data.medians
        }
    }
    
    func reset() {
        currentStrokeIndex = 0
        isFinished = false
        expectedStartOnScreen = nil
        expectedEndOnScreen = nil
    }
    
    func updateExpectedPoints(for bounds: CGRect) {
        guard currentStrokeIndex < expectedStrokes.count else {
            expectedStartOnScreen = nil
            expectedEndOnScreen = nil
            return
        }
        let targetStroke = expectedStrokes[currentStrokeIndex]
        guard let targetFirstPoint = targetStroke.first, let targetLastPoint = targetStroke.last else {
            expectedStartOnScreen = nil
            expectedEndOnScreen = nil
            return
        }
        
        let scaleX = bounds.width / 1024.0
        let scaleY = bounds.height / 1024.0
        
        expectedStartOnScreen = CGPoint(
            x: CGFloat(targetFirstPoint[0]) * scaleX,
            y: CGFloat(targetFirstPoint[1]) * scaleY
        )
        expectedEndOnScreen = CGPoint(
            x: CGFloat(targetLastPoint[0]) * scaleX,
            y: CGFloat(targetLastPoint[1]) * scaleY
        )
    }
    
    func validateStroke(_ stroke: PKStroke, canvasBounds: CGRect) -> Bool {
        print("--- STROKE VALIDATION DIAGNOSTICS ---")
        print("Canvas Bounds Width: \(canvasBounds.width), Height: \(canvasBounds.height)")
        if canvasBounds.width == 0 || canvasBounds.height == 0 {
            print("WARNING: Canvas bounds are 0!")
        }
        
        guard currentStrokeIndex < expectedStrokes.count else {
            print("Failed: currentStrokeIndex \(currentStrokeIndex) >= expectedStrokes.count \(expectedStrokes.count)")
            return false
        }
        
        let targetStroke = expectedStrokes[currentStrokeIndex]
        guard let targetFirstPoint = targetStroke.first, let targetLastPoint = targetStroke.last else {
            print("Failed: expected stroke points are nil at index \(currentStrokeIndex)")
            return false
        }
        
        print("Raw JSON Expected Start: \(targetFirstPoint), Expected End: \(targetLastPoint)")
        
        guard let userPathFirst = stroke.path.first, let userPathLast = stroke.path.last else {
            print("Failed: user stroke path first/last points are nil")
            return false
        }
        
        let userFirst = userPathFirst.location
        let userLast = userPathLast.location
        print("Actual User Start: \(userFirst), Actual User End: \(userLast)")
        
        let scaleX = canvasBounds.width / 1024.0
        let scaleY = canvasBounds.height / 1024.0
        print("Calculated scaleX: \(scaleX), scaleY: \(scaleY)")
        
        let expectedFirstPoint = CGPoint(
            x: CGFloat(targetFirstPoint[0]) * scaleX,
            y: CGFloat(targetFirstPoint[1]) * scaleY
        )
        
        let expectedLastPoint = CGPoint(
            x: CGFloat(targetLastPoint[0]) * scaleX,
            y: CGFloat(targetLastPoint[1]) * scaleY
        )
        print("Scaled Expected Start: \(expectedFirstPoint), Scaled Expected End: \(expectedLastPoint)")
        
        let startDist = hypot(userFirst.x - expectedFirstPoint.x, userFirst.y - expectedFirstPoint.y)
        let endDist = hypot(userLast.x - expectedLastPoint.x, userLast.y - expectedLastPoint.y)
        print("Euclidean Start Distance: \(startDist), End Distance: \(endDist)")
        
        if startDist <= maxDistanceTolerance && endDist <= maxDistanceTolerance {
            print("Success: Stroke validated!")
            currentStrokeIndex += 1
            if currentStrokeIndex >= expectedStrokes.count {
                isFinished = true
            }
            updateExpectedPoints(for: canvasBounds)
            return true
        } else {
            if startDist > maxDistanceTolerance {
                print("Failed: Start point distance was \(startDist), which is > \(maxDistanceTolerance) tolerance")
            }
            if endDist > maxDistanceTolerance {
                print("Failed: End point distance was \(endDist), which is > \(maxDistanceTolerance) tolerance")
            }
            return false
        }
    }
}
