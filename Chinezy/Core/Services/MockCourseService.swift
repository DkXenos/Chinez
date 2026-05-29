import Foundation

public class MockCourseService {

    public static func fetchMockCourses() -> [Course] {
        [
            Course(
                title: "Bab 1: Perkenalan Diri",
                description: "Belajar menyapa, berkenalan, dan menanyakan umur atau profesi.",
                subChapters: [
                    SubChapter(
                        title: "1.1 Menyapa",
                        flashcards: [
                            Flashcard(hanzi: "你好", pinyin: "nǐ hǎo", indonesianTranslation: "halo", imageRef: "hand.wave.fill"),
                            Flashcard(hanzi: "我", pinyin: "wǒ", indonesianTranslation: "saya", imageRef: "person.fill"),
                            Flashcard(hanzi: "你", pinyin: "nǐ", indonesianTranslation: "kamu", imageRef: "person"),
                            Flashcard(hanzi: "叫", pinyin: "jiào", indonesianTranslation: "bernama / memanggil", imageRef: "bubble.left.and.bubble.right.fill"),
                            Flashcard(hanzi: "名字", pinyin: "míngzi", indonesianTranslation: "nama", imageRef: "lanyardcard.fill"),
                            Flashcard(hanzi: "什么", pinyin: "shénme", indonesianTranslation: "apa", imageRef: "questionmark.circle.fill")
                        ],
                        dialogText: "A: 你好！\nB: 你好！你叫什么名字？\nA: 我叫王明。\nB: 我叫李娜。"
                    ),
                    SubChapter(
                        title: "1.2 Berkenalan",
                        flashcards: [
                            Flashcard(hanzi: "认识", pinyin: "rènshi", indonesianTranslation: "mengenal", imageRef: "person.2.fill"),
                            Flashcard(hanzi: "高兴", pinyin: "gāoxìng", indonesianTranslation: "senang", imageRef: "face.smiling"),
                            Flashcard(hanzi: "很", pinyin: "hěn", indonesianTranslation: "sangat", imageRef: "exclamationmark.3"),
                            Flashcard(hanzi: "也", pinyin: "yě", indonesianTranslation: "juga", imageRef: "plus.square.fill.on.square.fill"),
                            Flashcard(hanzi: "朋友", pinyin: "péngyou", indonesianTranslation: "teman", imageRef: "figure.2.arms.open"),
                            Flashcard(hanzi: "谁", pinyin: "shéi", indonesianTranslation: "siapa", imageRef: "person.crop.circle.badge.questionmark")
                        ],
                        dialogText: "A: 他是谁？\nB: 他是我的朋友。\nA: 很高兴认识你。\nB: 我也很高兴认识你。"
                    ),
                    SubChapter(
                        title: "1.3 Murid atau Guru",
                        flashcards: [
                            Flashcard(hanzi: "老师", pinyin: "lǎoshī", indonesianTranslation: "guru", imageRef: "graduationcap.fill"),
                            Flashcard(hanzi: "学生", pinyin: "xuésheng", indonesianTranslation: "murid", imageRef: "book.fill"),
                            Flashcard(hanzi: "不", pinyin: "bù", indonesianTranslation: "tidak / bukan", imageRef: "xmark.circle.fill"),
                            Flashcard(hanzi: "多大", pinyin: "duō dà", indonesianTranslation: "berapa umur", imageRef: "clock.arrow.circlepath"),
                            Flashcard(hanzi: "今年", pinyin: "jīnnián", indonesianTranslation: "tahun ini", imageRef: "calendar"),
                            Flashcard(hanzi: "岁", pinyin: "suì", indonesianTranslation: "tahun (usia)", imageRef: "birthday.cake.fill")
                        ],
                        dialogText: "A: 你是老师吗？\nB: 不，我是学生。\nA: 你今年多大？\nB: 我今年十八岁。"
                    )
                ]
            ),
            Course(
                title: "Bab 2: Asal Negara",
                description: "Belajar menanyakan asal negara, bahasa, dan kota tempat tinggal.",
                subChapters: [
                    SubChapter(
                        title: "2.1 Dari Negara Mana",
                        flashcards: [
                            Flashcard(hanzi: "哪", pinyin: "nǎ", indonesianTranslation: "mana", imageRef: "map.fill"),
                            Flashcard(hanzi: "国", pinyin: "guó", indonesianTranslation: "negara", imageRef: "globe"),
                            Flashcard(hanzi: "人", pinyin: "rén", indonesianTranslation: "orang", imageRef: "person.fill"),
                            Flashcard(hanzi: "中国", pinyin: "Zhōngguó", indonesianTranslation: "Tiongkok", imageRef: "flag.fill"),
                            Flashcard(hanzi: "印尼", pinyin: "Yìnní", indonesianTranslation: "Indonesia", imageRef: "flag.fill"),
                            Flashcard(hanzi: "来", pinyin: "lái", indonesianTranslation: "datang / berasal", imageRef: "arrow.down.right.circle.fill")
                        ],
                        dialogText: "A: 你是哪国人？\nB: 我是中国人。\nA: 我是印尼人。你从哪里来？\nB: 我从北京来。"
                    ),
                    SubChapter(
                        title: "2.2 Negara Lain",
                        flashcards: [
                            Flashcard(hanzi: "美国", pinyin: "Měiguó", indonesianTranslation: "Amerika Serikat", imageRef: "flag.fill"),
                            Flashcard(hanzi: "日本", pinyin: "Rìběn", indonesianTranslation: "Jepang", imageRef: "flag.fill"),
                            Flashcard(hanzi: "英国", pinyin: "Yīngguó", indonesianTranslation: "Inggris", imageRef: "flag.fill"),
                            Flashcard(hanzi: "他们", pinyin: "tāmen", indonesianTranslation: "mereka", imageRef: "person.3.fill"),
                            Flashcard(hanzi: "对", pinyin: "duì", indonesianTranslation: "benar/ya", imageRef: "checkmark.circle.fill")
                        ],
                        dialogText: "A: 他是美国人吗？\nB: 不是，他是日本人。\nA: 他们是英国人吗？\nB: 对，他们是英国人。"
                    ),
                    SubChapter(
                        title: "2.3 Bahasa & Kota",
                        flashcards: [
                            Flashcard(hanzi: "会", pinyin: "huì", indonesianTranslation: "bisa", imageRef: "lightbulb.fill"),
                            Flashcard(hanzi: "说", pinyin: "shuō", indonesianTranslation: "berbicara", imageRef: "bubble.left.fill"),
                            Flashcard(hanzi: "汉语", pinyin: "Hànyǔ", indonesianTranslation: "bahasa Mandarin", imageRef: "character.bubble.fill"),
                            Flashcard(hanzi: "一点儿", pinyin: "yìdiǎnr", indonesianTranslation: "sedikit", imageRef: "hand.point.up.left.fill"),
                            Flashcard(hanzi: "住", pinyin: "zhù", indonesianTranslation: "tinggal", imageRef: "house.fill"),
                            Flashcard(hanzi: "城市", pinyin: "chéngshì", indonesianTranslation: "kota", imageRef: "building.2.fill")
                        ],
                        dialogText: "A: 你会说汉语吗？\nB: 我会说一点儿。\nA: 你住在哪个城市？\nB: 我住在上海。"
                    )
                ]
            )
        ]
    }
}
