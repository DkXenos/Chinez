import SwiftUI

enum ExerciseMode: String, CaseIterable, Hashable {
    case listening = "Listening"
    case stroke = "Stroke"
    case reading = "Reading"
    
    var iconName: String {
        switch self {
        case .listening: return "ear"
        case .stroke: return "pencil.and.outline"
        case .reading: return "book"
        }
    }
}

struct ExerciseNavBar: View {
    @Binding var selectedMode: ExerciseMode
    
    var body: some View {
        HStack {
            ForEach(ExerciseMode.allCases, id: \.self) { mode in
                Button(action: {
                    withAnimation {
                        selectedMode = mode
                    }
                }) {
                    VStack {
                        Image(systemName: mode.iconName)
                            .font(.system(size: 24))
                        Text(mode.rawValue)
                            .font(DesignSystem.Typography.caption)
                    }
                    .foregroundColor(selectedMode == mode ? DesignSystem.Colors.primary : DesignSystem.Colors.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, DesignSystem.Dimensions.paddingStandard)
                }
            }
        }
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .padding(.horizontal, DesignSystem.Dimensions.paddingStandard)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
