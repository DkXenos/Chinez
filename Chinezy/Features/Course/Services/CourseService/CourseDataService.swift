import Foundation

struct CourseDataWrapper: Codable {
    let courses: [Course]
}

struct CourseDataService: CourseService {
    
    enum DataError: LocalizedError {
        case fileNotFound
        case decodingFailed(Error)
        
        var errorDescription: String? {
            switch self {
            case .fileNotFound:
                return "File courses.json not found in app bundle."
            case .decodingFailed(let error):
                return "Failed to read courses.json: \(error.localizedDescription)"
            }
        }
    }
    
    private let resourceName: String
    
    init(resourceName: String = "courses") {
        self.resourceName = resourceName
    }
    
    private func loadCourses() throws -> [Course] {
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: "json") else {
            throw DataError.fileNotFound
        }
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(CourseDataWrapper.self, from: data)
            return decoded.courses
        } catch let error as DataError {
            throw error
        } catch {
            throw DataError.decodingFailed(error)
        }
    }
    
    func fetchCourses() -> [Course] {
        do {
            return try loadCourses()
        } catch {
            print("Error loading courses: \(error.localizedDescription)")
            return []
        }
    }
}
