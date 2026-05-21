import SwiftUI

struct ThemeCard: View {
    let theme: Theme
    
    var body: some View {
        VStack(spacing: DesignSystem.Dimensions.paddingStandard) {
            Image(systemName: theme.iconName)
                .font(.system(size: 40))
                .foregroundColor(theme.isLocked ? DesignSystem.Colors.textSecondary : DesignSystem.Colors.primary)
            
            Text(theme.name)
                .font(DesignSystem.Typography.headline)
                .foregroundColor(DesignSystem.Colors.textPrimary)
            
            if theme.isLocked {
                Image(systemName: "lock.fill")
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(DesignSystem.Dimensions.paddingLarge)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadius, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}
