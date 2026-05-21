import SwiftUI

struct PartSelectionView: View {
    let theme: Theme
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var viewModel = PartSelectionViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.parts) { part in
                Button(action: {
                    router.startExercise(part: part)
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(part.name)
                                .font(DesignSystem.Typography.headline)
                                .foregroundColor(DesignSystem.Colors.textPrimary)
                            Text("\(part.characterCount) characters")
                                .font(DesignSystem.Typography.caption)
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                        }
                        
                        Spacer()
                        
                        CircularProgressView(progress: part.progress)
                            .frame(width: 40, height: 40)
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .navigationTitle(theme.name)
        .background(DesignSystem.Colors.background.ignoresSafeArea())
    }
}

struct CircularProgressView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(DesignSystem.Colors.secondaryBackground, lineWidth: 4)
            Circle()
                .trim(from: 0, to: CGFloat(progress))
                .stroke(DesignSystem.Colors.primary, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}
