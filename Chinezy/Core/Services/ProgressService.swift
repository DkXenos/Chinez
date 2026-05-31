import Foundation
import FirebaseFirestore

struct ProgressService {
    private let db = Firestore.firestore()
    
    func incrementQuizCompletion(for uid: String, chapterID: String) async throws {
        let userRef = db.collection("users").document(uid)
        
        try await userRef.updateData([
            "totalQuizzesCompleted": FieldValue.increment(Int64(1)),
            "completedChapters": FieldValue.arrayUnion([chapterID])
        ])
    }
}
