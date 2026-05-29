import Foundation
import Combine

public class CourseListViewModel: ObservableObject {
    @Published public var courses: [Course] = []

    public init() {}

    public func loadCourses() {
        courses = MockCourseService.fetchMockCourses()
    }
}
