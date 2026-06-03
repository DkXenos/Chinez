import SwiftUI
import Combine

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            ZStack {
                DesignSystem.Colors.background
                    .ignoresSafeArea()
                
                if authManager.currentUserProfile == nil {
                    VStack {
                        ProgressView("Loading Profile...")
                            .padding()
                        
                        // Fallback Sign Out button in case fetching fails permanently
                        Button(role: .destructive, action: signOut) {
                            Text("Sign Out")
                        }
                        .padding(.top)
                    }
                } else {
                    dashboard
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var dashboard: some View {
        Form {
            Section {
                VStack(spacing: DesignSystem.Dimensions.paddingStandard) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [DesignSystem.Colors.primary, DesignSystem.Colors.gold],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 90, height: 90)

                        Image(systemName: "person.fill")
                            .font(.system(size: 38, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    
                    if let profile = authManager.currentUserProfile {
                        Text(profile.email)
                            .font(DesignSystem.Typography.headline)
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                    }
                }
                .padding(.vertical, DesignSystem.Dimensions.paddingStandard)
                .listRowBackground(Color.clear)
            }
            
            Section(header: Text("Progress Info")) {
                if let profile = authManager.currentUserProfile {
                    HStack {
                        Text("Passed Quizzes")
                        Spacer()
                        let passedCount = profile.quizScores.values.filter { $0 >= 70 }.count
                        Text("\(passedCount)")
                            .foregroundColor(.secondary)
                            .bold()
                    }
                }
            }
            
            Section {
                Button(role: .destructive, action: signOut) {
                    Text("Sign Out")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            
            if let errorMessage = errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
            }
        }
        .scrollContentBackground(.hidden)
    }
    
    private func signOut() {
        do {
            try authManager.signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthManager())
}
