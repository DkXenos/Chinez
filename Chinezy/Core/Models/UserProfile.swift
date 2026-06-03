import SwiftUI
import Combine
import Foundation

struct UserProfile: Codable, Identifiable {
    let id: String
    let email: String
    var quizScores: [String: Int]
    
    var dictionary: [String: Any] {
        return [
            "id": id,
            "email": email,
            "quizScores": quizScores
        ]
    }
    
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let email = dictionary["email"] as? String else {
            return nil
        }
        
        self.id = id
        self.email = email
        self.quizScores = dictionary["quizScores"] as? [String: Int] ?? [:]
    }
    
    init(id: String, email: String, quizScores: [String: Int]) {
        self.id = id
        self.email = email
        self.quizScores = quizScores
    }
}
