import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authManager: AuthManager
    
    @State private var isLoginMode = true
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showError = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background matching the rest of the app
                DesignSystem.Colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: DesignSystem.Dimensions.paddingLarge) {
                        
                        // Header
                        VStack(spacing: DesignSystem.Dimensions.paddingSmall) {
                            Text(isLoginMode ? "Welcome Back" : "Create Account")
                                .font(DesignSystem.Typography.largeTitle)
                                .foregroundColor(DesignSystem.Colors.textDark)
                                .multilineTextAlignment(.center)
                                .accessibilityIdentifier("Auth.WelcomeHeader")
                            
                            Text(isLoginMode ? "Log in to continue your learning journey" : "Sign up to start mastering Chinese")
                                .font(DesignSystem.Typography.body)
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                                .multilineTextAlignment(.center)
                                .accessibilityIdentifier("Auth.Subtitle")
                        }
                        .padding(.top, 60)
                        .padding(.bottom, 20)
                        
                        // Input Fields
                        VStack(spacing: DesignSystem.Dimensions.paddingStandard) {
                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .padding(DesignSystem.Dimensions.paddingStandard)
                                .accessibilityIdentifier("Auth.EmailField")
                                .background(DesignSystem.Colors.surfaceWhite)
                                .cornerRadius(DesignSystem.Dimensions.cornerRadiusSmall)
                                .foregroundColor(DesignSystem.Colors.textPrimary)
                                .overlay(
                                    RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadiusSmall)
                                        .stroke(DesignSystem.Colors.cardBorder, lineWidth: 1)
                                )
                            
                            SecureField("Password", text: $password)
                                .padding(DesignSystem.Dimensions.paddingStandard)
                                .accessibilityIdentifier("Auth.PasswordField")
                                .background(DesignSystem.Colors.surfaceWhite)
                                .cornerRadius(DesignSystem.Dimensions.cornerRadiusSmall)
                                .foregroundColor(DesignSystem.Colors.textPrimary)
                                .overlay(
                                    RoundedRectangle(cornerRadius: DesignSystem.Dimensions.cornerRadiusSmall)
                                        .stroke(DesignSystem.Colors.cardBorder, lineWidth: 1)
                                )
                        }
                        
                        // Action Button
                        Button(action: handleAction) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text(isLoginMode ? "Log In" : "Sign Up")
                                        .font(DesignSystem.Typography.headline)
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(DesignSystem.Dimensions.paddingStandard)
                            .background(DesignSystem.Colors.primary)
                            .cornerRadius(DesignSystem.Dimensions.cornerRadius)
                            .opacity((isLoading || email.isEmpty || password.isEmpty) ? 0.6 : 1.0)
                        }
                        .disabled(isLoading || email.isEmpty || password.isEmpty)
                        .padding(.top, DesignSystem.Dimensions.paddingSmall)
                        .accessibilityIdentifier("Auth.ActionButton")
                        
                        // Toggle Mode Button
                        Button(action: {
                            withAnimation {
                                isLoginMode.toggle()
                                errorMessage = nil
                            }
                        }) {
                            Text(isLoginMode ? "Need an account? Sign Up" : "Already have an account? Log In")
                                .font(DesignSystem.Typography.subheadlineBold)
                                .foregroundColor(DesignSystem.Colors.primary)
                        }
                        .padding(.top, DesignSystem.Dimensions.paddingStandard)
                        .accessibilityIdentifier("Auth.ToggleButton")
                        
                        Spacer()
                    }
                    .padding(.horizontal, DesignSystem.Dimensions.paddingLarge)
                    // Restrict max width for iPad so the form doesn't stretch edge-to-edge
                    .frame(maxWidth: 500)
                }
            }
            .navigationBarHidden(true)
            .alert("Error", isPresented: $showError, presenting: errorMessage) { _ in
                Button("OK", role: .cancel) { }
            } message: { msg in
                Text(msg)
            }
        }
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
                showError = true
            }
            isLoading = false
        }
    }
}

#Preview {
    AuthView()
        .environmentObject(AuthManager())
}
