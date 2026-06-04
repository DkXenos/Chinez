import Foundation


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


struct ToneGroup: Identifiable, Hashable {
    let id: UUID
    let toneNumber: Int
    let title: String
    let description: String
    let icon: String
    let targets: [HanziTarget]
    
    init(toneNumber: Int, title: String, description: String, icon: String, targets: [HanziTarget]) {
        self.id = UUID()
        self.toneNumber = toneNumber
        self.title = title
        self.description = description
        self.icon = icon
        self.targets = targets
    }
}


extension HanziTarget {

    static let defaults: [HanziTarget] = ToneGroup.allGroups.flatMap { $0.targets }
}


extension ToneGroup {
    
    static let allGroups: [ToneGroup] = [
        ToneGroup(
            toneNumber: 1,
            title: "Tone 1 — Flat (¯)",
            description: "High and level pitch, like sustaining a musical note.",
            icon: "minus",
            targets: [
                HanziTarget(character: "妈", pinyin: "mā", targetTone: "Tone_1"),
                HanziTarget(character: "他", pinyin: "tā", targetTone: "Tone_1"),
                HanziTarget(character: "书", pinyin: "shū", targetTone: "Tone_1"),
                HanziTarget(character: "吃", pinyin: "chī", targetTone: "Tone_1"),
                HanziTarget(character: "飞", pinyin: "fēi", targetTone: "Tone_1"),
                HanziTarget(character: "天", pinyin: "tiān", targetTone: "Tone_1"),
                HanziTarget(character: "花", pinyin: "huā", targetTone: "Tone_1"),
                HanziTarget(character: "猫", pinyin: "māo", targetTone: "Tone_1"),
            ]
        ),
        ToneGroup(
            toneNumber: 2,
            title: "Tone 2 — Rising (ˊ)",
            description: "Pitch rises from mid to high, like asking 'huh?'",
            icon: "arrow.up.right",
            targets: [
                HanziTarget(character: "麻", pinyin: "má", targetTone: "Tone_2"),
                HanziTarget(character: "人", pinyin: "rén", targetTone: "Tone_2"),
                HanziTarget(character: "来", pinyin: "lái", targetTone: "Tone_2"),
                HanziTarget(character: "学", pinyin: "xué", targetTone: "Tone_2"),
                HanziTarget(character: "鱼", pinyin: "yú", targetTone: "Tone_2"),
                HanziTarget(character: "国", pinyin: "guó", targetTone: "Tone_2"),
                HanziTarget(character: "男", pinyin: "nán", targetTone: "Tone_2"),
                HanziTarget(character: "朋", pinyin: "péng", targetTone: "Tone_2"),
            ]
        ),
        ToneGroup(
            toneNumber: 3,
            title: "Tone 3 — Dipping (ˇ)",
            description: "Pitch falls then rises, like saying 'well…' thoughtfully.",
            icon: "arrow.down.right",
            targets: [
                HanziTarget(character: "马", pinyin: "mǎ", targetTone: "Tone_3"),
                HanziTarget(character: "你", pinyin: "nǐ", targetTone: "Tone_3"),
                HanziTarget(character: "我", pinyin: "wǒ", targetTone: "Tone_3"),
                HanziTarget(character: "好", pinyin: "hǎo", targetTone: "Tone_3"),
                HanziTarget(character: "小", pinyin: "xiǎo", targetTone: "Tone_3"),
                HanziTarget(character: "水", pinyin: "shuǐ", targetTone: "Tone_3"),
                HanziTarget(character: "狗", pinyin: "gǒu", targetTone: "Tone_3"),
                HanziTarget(character: "五", pinyin: "wǔ", targetTone: "Tone_3"),
            ]
        ),
        ToneGroup(
            toneNumber: 4,
            title: "Tone 4 — Falling (ˋ)",
            description: "Pitch drops sharply from high to low, like a firm 'no!'",
            icon: "arrow.down.left",
            targets: [
                HanziTarget(character: "骂", pinyin: "mà", targetTone: "Tone_4"),
                HanziTarget(character: "大", pinyin: "dà", targetTone: "Tone_4"),
                HanziTarget(character: "四", pinyin: "sì", targetTone: "Tone_4"),
                HanziTarget(character: "看", pinyin: "kàn", targetTone: "Tone_4"),
                HanziTarget(character: "是", pinyin: "shì", targetTone: "Tone_4"),
                HanziTarget(character: "去", pinyin: "qù", targetTone: "Tone_4"),
                HanziTarget(character: "测", pinyin: "cè", targetTone: "Tone_4"),
                HanziTarget(character: "对", pinyin: "duì", targetTone: "Tone_4"),
            ]
        ),
    ]
}
