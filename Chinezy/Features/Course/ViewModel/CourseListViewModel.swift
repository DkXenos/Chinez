import SwiftUI
import Foundation
import Combine

public class CourseListViewModel: ObservableObject {
    @Published var courses: [Course] = []
    @Published var searchText: String = ""

    private let courseService: CourseService

    init(courseService: CourseService = CourseDataService()) {
        self.courseService = courseService
    }

    var filteredCourses: [Course] {
        if searchText.isEmpty {
            return courses
        } else {
            return courses.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }

    func loadCourses() {
        courses = courseService.fetchCourses()
    }
}
