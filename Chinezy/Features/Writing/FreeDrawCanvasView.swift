import SwiftUI

struct FreeDrawCanvasView: View {
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var viewModel = FreeDrawCanvasViewModel()
    
    var body: some View {
        VStack(spacing: DesignSystem.Dimensions.paddingLarge) {
            
            HStack(spacing: DesignSystem.Dimensions.paddingStandard) {
                Text(viewModel.recognizedCharacter.isEmpty ? "..." : viewModel.recognizedCharacter)
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                
                Text(viewModel.pinyin.isEmpty ? "" : viewModel.pinyin)
                    .font(DesignSystem.Typography.title)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
            .padding(.top, DesignSystem.Dimensions.paddingLarge)
            
            Spacer()
            
            CanvasPlaceholder()
                .padding(DesignSystem.Dimensions.paddingLarge)
            
            Spacer()
            
            PrimaryButton(title: "Clear", systemImage: "trash") {
                viewModel.clearCanvas()
            }
            .padding(.horizontal, DesignSystem.Dimensions.paddingLarge)
            .padding(.bottom, DesignSystem.Dimensions.paddingLarge)
        }
        .background(DesignSystem.Colors.background.ignoresSafeArea())
    }
}
