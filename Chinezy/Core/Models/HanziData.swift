import Foundation

struct HanziData: Codable {
    let character: String
    let medians: [[[Int]]]
}
