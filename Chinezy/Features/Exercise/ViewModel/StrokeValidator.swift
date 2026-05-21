import Foundation
import PencilKit
import Combine
import CoreGraphics

class StrokeValidator: ObservableObject {
    @Published var currentStrokeIndex: Int = 0
    @Published var isFinished: Bool = false
    
    let targetCharacter: String
    private var expectedStrokes: [[[Int]]] = []
    
    private let maxDistanceTolerance: CGFloat = 40.0
    
    init(character: String) {
        self.targetCharacter = character
        if let data = HanziDataManager.shared.dictionary[character] {
            self.expectedStrokes = data.medians
        }
    }
    
    func reset() {
        currentStrokeIndex = 0
        isFinished = false
    }
    
    func validateStroke(_ stroke: PKStroke, canvasBounds: CGRect) -> Bool {
        guard currentStrokeIndex < expectedStrokes.count else {
            return false
        }
        
        let targetStroke = expectedStrokes[currentStrokeIndex]
        guard let targetFirstPoint = targetStroke.first, let targetLastPoint = targetStroke.last else {
            return false
        }
        
        guard let userPathFirst = stroke.path.first, let userPathLast = stroke.path.last else {
            return false
        }
        
        let userFirst = userPathFirst.location
        let userLast = userPathLast.location
        
        let scaleX = canvasBounds.width / 1024.0
        let scaleY = canvasBounds.height / 1024.0
        
        let expectedFirstPoint = CGPoint(
            x: CGFloat(targetFirstPoint[0]) * scaleX,
            y: CGFloat(targetFirstPoint[1]) * scaleY
        )
        
        let expectedLastPoint = CGPoint(
            x: CGFloat(targetLastPoint[0]) * scaleX,
            y: CGFloat(targetLastPoint[1]) * scaleY
        )
        
        let startDist = hypot(userFirst.x - expectedFirstPoint.x, userFirst.y - expectedFirstPoint.y)
        let endDist = hypot(userLast.x - expectedLastPoint.x, userLast.y - expectedLastPoint.y)
        
        if startDist <= maxDistanceTolerance && endDist <= maxDistanceTolerance {
            currentStrokeIndex += 1
            if currentStrokeIndex >= expectedStrokes.count {
                isFinished = true
            }
            return true
        } else {
            return false
        }
    }
}
