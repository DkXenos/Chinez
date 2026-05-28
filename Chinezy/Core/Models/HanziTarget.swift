import Foundation

// MARK: - Hanzi Practice Target

/// A single Hanzi character the user practices pronouncing with the correct tone.
struct HanziTarget: Identifiable, Hashable {
    let id: UUID
    let character: String
    let pinyin: String
    let targetTone: String

    init(character: String, pinyin: String, targetTone: String) {
        self.id = UUID()
        self.character = character
        self.pinyin = pinyin
        self.targetTone = targetTone
    }

    /// The numeric tone value (1–4) extracted from `targetTone`, or `nil` for noise.
    var toneNumber: Int? {
        switch targetTone {
        case "Tone_1": return 1
        case "Tone_2": return 2
        case "Tone_3": return 3
        case "Tone_4": return 4
        default:       return nil
        }
    }
}

// MARK: - Default Targets

extension HanziTarget {

    /// Five practice targets covering all four tones.
    static let defaults: [HanziTarget] = [
        HanziTarget(character: "妈", pinyin: "mā", targetTone: "Tone_1"),
        HanziTarget(character: "麻", pinyin: "má", targetTone: "Tone_2"),
        HanziTarget(character: "马", pinyin: "mǎ", targetTone: "Tone_3"),
        HanziTarget(character: "骂", pinyin: "mà", targetTone: "Tone_4"),
        HanziTarget(character: "测", pinyin: "cè", targetTone: "Tone_4"),
    ]
}
