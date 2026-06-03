import SwiftUI
import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class AuthManager: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUserProfile: UserProfile?
    
    private let db = Firestore.firestore()
    
    init() {
        self.userSession = Auth.auth().currentUser
        if self.userSession != nil {
            Task {
                await fetchCurrentUserProfile()
            }
        }
    }
    
    func signIn(email: String, password: String) async throws {
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        self.userSession = authResult.user
        await fetchCurrentUserProfile()
    }
    
    func signUp(email: String, password: String) async throws {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        let user = authResult.user
        
        let newProfile = UserProfile(
            id: user.uid,
            email: email,
            quizScores: [:]
        )
        
        try await db.collection("users").document(user.uid).setData(newProfile.dictionary)
        
        self.userSession = user
        self.currentUserProfile = newProfile
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        self.userSession = nil
        self.currentUserProfile = nil
    }
    
    func fetchCurrentUserProfile() async {
        guard let uid = userSession?.uid else { return }
        
        do {
            let document = try await db.collection("users").document(uid).getDocument()
            if document.exists, let data = document.data() {
                self.currentUserProfile = UserProfile(dictionary: data)
            } else {
                // Fix infinite loading: if the user document is missing, create a default one
                let email = userSession?.email ?? "unknown@example.com"
                let newProfile = UserProfile(id: uid, email: email, quizScores: [:])
                try await db.collection("users").document(uid).setData(newProfile.dictionary)
                self.currentUserProfile = newProfile
            }
        } catch {
            print("Failed to fetch user profile: \(error.localizedDescription)")
        }
    }
    
    func saveQuizScore(quizId: String, percentage: Int) async {
        guard let uid = userSession?.uid, var currentProfile = currentUserProfile else { return }
        
        // Only update if the new score is higher than the currently saved score
        let currentScore = currentProfile.quizScores[quizId] ?? -1
        guard percentage > currentScore else { return }
        
        do {
            try await db.collection("users").document(uid).updateData([
                "quizScores.\(quizId)": percentage
            ])
            
            // Update local state immediately
            currentProfile.quizScores[quizId] = percentage
            self.currentUserProfile = currentProfile
        } catch {
            print("Failed to save quiz score: \(error.localizedDescription)")
        }
    }

    deinit {}
}
