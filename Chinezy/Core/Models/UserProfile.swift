import SwiftUI
import Combine
import Foundation

struct UserProfile: Codable, Identifiable {
    let id: String
    let email: String
    var totalQuizzesCompleted: Int
    var completedChapters: [String]
    
    var dictionary: [String: Any] {
        return [
            "id": id,
            "email": email,
            "totalQuizzesCompleted": totalQuizzesCompleted,
            "completedChapters": completedChapters
        ]
    }
    
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let email = dictionary["email"] as? String,
              let totalQuizzesCompleted = dictionary["totalQuizzesCompleted"] as? Int,
              let completedChapters = dictionary["completedChapters"] as? [String] else {
            return nil
        }
        
        self.id = id
        self.email = email
        self.totalQuizzesCompleted = totalQuizzesCompleted
        self.completedChapters = completedChapters
    }
    
    init(id: String, email: String, totalQuizzesCompleted: Int, completedChapters: [String]) {
        self.id = id
        self.email = email
        self.totalQuizzesCompleted = totalQuizzesCompleted
        self.completedChapters = completedChapters
    }
}
