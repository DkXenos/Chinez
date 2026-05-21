import SwiftUI

struct LandingView: View {
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        VStack(spacing: DesignSystem.Dimensions.paddingLarge) {
            Spacer()
            
            Image(systemName: "character.book.closed.fill")
                .font(.system(size: 80))
                .foregroundColor(DesignSystem.Colors.primary)
            
            Text("Hanzi Academy")
                .font(DesignSystem.Typography.largeTitle)
                .foregroundColor(DesignSystem.Colors.textPrimary)
            
            Spacer()
            
            VStack(spacing: DesignSystem.Dimensions.paddingStandard) {
                PrimaryButton(title: "Sign In with Apple", systemImage: "applelogo") {
                    router.navigateToHome()
                }
                
                PrimaryButton(title: "Get Started", systemImage: nil) {
                    router.navigateToHome()
                }
            }
            .padding(.horizontal, DesignSystem.Dimensions.paddingLarge)
        }
        .padding(.bottom, DesignSystem.Dimensions.paddingLarge)
        .background(DesignSystem.Colors.background.ignoresSafeArea())
    }
}
