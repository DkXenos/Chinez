import Foundation

struct CourseDataWrapper: Codable {
    let courses: [Course]
}

protocol CourseDataServiceProtocol: CourseService {
    func loadCourses() throws -> [Course]
}

struct CourseDataService: CourseDataServiceProtocol {
    
    enum DataError: LocalizedError {
        case fileNotFound
        case decodingFailed(Error)
        
        var errorDescription: String? {
            switch self {
            case .fileNotFound:
                return "File courses.json tidak ditemukan di bundle aplikasi."
            case .decodingFailed(let error):
                return "Gagal membaca courses.json: \(error.localizedDescription)"
            }
        }
    }
    
    private let resourceName: String
    
    init(resourceName: String = "courses") {
        self.resourceName = resourceName
    }
    
    func loadCourses() throws -> [Course] {
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
