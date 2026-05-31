import SwiftUI

struct FreeDrawCanvasView: View {
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var viewModel = FreeDrawCanvasViewModel()
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: DesignSystem.Dimensions.paddingLarge) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24, weight: .semibold))
                    }
                    .foregroundStyle(Color.black)
                }
                
                Spacer()
            }
            .padding(.horizontal, DesignSystem.Dimensions.paddingLarge)
            .padding(.top, 12)

            
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
