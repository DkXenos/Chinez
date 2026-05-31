import Combine
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    
    @State private var email = ""
    @State private var password = ""
    @State private var isLoginMode = true
    @State private var errorMessage: String?
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                DesignSystem.Colors.background
                    .ignoresSafeArea()
                
                if authManager.userSession == nil {
                    loginForm
                } else {
                    dashboard
                }
            }
            .navigationTitle(authManager.userSession == nil ? (isLoginMode ? "Log In" : "Register") : "Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var loginForm: some View {
        Form {
            Section(header: Text(isLoginMode ? "Welcome Back" : "Create Account")) {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                SecureField("Password", text: $password)
            }
            
            if let errorMessage = errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
            }
            
            Section {
                Button(action: handleAction) {
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        Text(isLoginMode ? "Log In" : "Sign Up")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(.white)
                    }
                }
                .disabled(isLoading || email.isEmpty || password.isEmpty)
                .listRowBackground(
                    (isLoading || email.isEmpty || password.isEmpty) ? Color.gray : DesignSystem.Colors.primary
                )
            }
            
            Section {
                Button(action: {
                    isLoginMode.toggle()
                    errorMessage = nil
                }) {
                    Text(isLoginMode ? "Need an account? Sign Up" : "Already have an account? Log In")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(DesignSystem.Colors.primary)
                }
            }
        }
        .scrollContentBackground(.hidden)
    }
    
    private var dashboard: some View {
        Form {
            // ── Avatar ─────────────────────────────────
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
                        Text("Quizzes Completed")
                        Spacer()
                        Text("\(profile.totalQuizzesCompleted)")
                            .foregroundColor(.secondary)
                            .bold()
                    }
                } else {
                    HStack {
                        Spacer()
                        ProgressView("Loading Profile...")
                        Spacer()
                    }
                }
            }
            
            Section {
                Button(role: .destructive, action: {
                    do {
                        try authManager.signOut()
                    } catch {
                        errorMessage = error.localizedDescription
                    }
                }) {
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
    
    private func handleAction() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                if isLoginMode {
                    try await authManager.signIn(email: email, password: password)
                } else {
                    try await authManager.signUp(email: email, password: password)
                }
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthManager())
}
