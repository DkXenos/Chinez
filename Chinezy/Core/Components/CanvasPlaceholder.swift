import SwiftUI

struct CanvasPlaceholder: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadius, style: .continuous)
                .fill(DesignSystem.Colors.secondaryBackground)
            
            Path { path in
                let step: CGFloat = 20
                for i in stride(from: 0, to: 1000, by: step) {
                    path.move(to: CGPoint(x: i, y: 0))
                    path.addLine(to: CGPoint(x: i, y: 1000))
                    path.move(to: CGPoint(x: 0, y: i))
                    path.addLine(to: CGPoint(x: 1000, y: i))
                }
            }
            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            .clipped()
            
        }
        .aspectRatio(1, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadius, style: .continuous))
    }
}
