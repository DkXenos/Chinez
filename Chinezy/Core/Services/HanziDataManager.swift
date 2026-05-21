import Foundation

class HanziDataManager {
    static let shared = HanziDataManager()
    
    private(set) var dictionary: [String: HanziData] = [:]
    
    private init() {
        loadData()
    }
    
    private func loadData() {
        guard let url = Bundle.main.url(forResource: "HSK1_StrokeData", withExtension: "json") else {
            print("Error: HSK1_StrokeData.json not found in main bundle.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedArray = try JSONDecoder().decode([HanziData].self, from: data)
            
            var dict: [String: HanziData] = [:]
            for hanzi in decodedArray {
                dict[hanzi.character] = hanzi
            }
            self.dictionary = dict
        } catch {
            print("Error parsing HSK1_StrokeData.json: \(error)")
        }
    }
}
