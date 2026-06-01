import Foundation

class MockCourseService: CourseService {

    public func fetchCourses() -> [Course] {
        [
            Course(
                title: "Bab 1: Perkenalan Diri",
                description: "Belajar menyapa, berkenalan, dan menanyakan umur atau profesi.",
                icon: "book.fill",
                subChapters: [
                    SubChapter(
                        title: "1.1 Menyapa",
                        flashcards: [
                            Flashcard(hanzi: "你好", pinyin: "nǐ hǎo", indonesianTranslation: "halo", imageRef: "hand.wave.fill", audioRef: "nihao"),
                            Flashcard(hanzi: "我", pinyin: "wǒ", indonesianTranslation: "saya", imageRef: "person.fill", audioRef: "wo"),
                            Flashcard(hanzi: "你", pinyin: "nǐ", indonesianTranslation: "kamu", imageRef: "person", audioRef: "ni"),
                            Flashcard(hanzi: "叫", pinyin: "jiào", indonesianTranslation: "bernama / memanggil", imageRef: "bubble.left.and.bubble.right.fill", audioRef: "jiao"),
                            Flashcard(hanzi: "名字", pinyin: "míngzi", indonesianTranslation: "nama", imageRef: "lanyardcard.fill", audioRef: "mingzi"),
                            Flashcard(hanzi: "什么", pinyin: "shénme", indonesianTranslation: "apa", imageRef: "questionmark.circle.fill", audioRef: "shenme")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "你好！"),
                            DialogLine(speaker: "B", text: "你好！你叫什么名字？"),
                            DialogLine(speaker: "A", text: "我叫王明。"),
                            DialogLine(speaker: "B", text: "我叫李娜。")
                        ]
                    ),
                    SubChapter(
                        title: "1.2 Berkenalan",
                        flashcards: [
                            Flashcard(hanzi: "认识", pinyin: "rènshi", indonesianTranslation: "mengenal", imageRef: "person.2.fill", audioRef: "renshi"),
                            Flashcard(hanzi: "高兴", pinyin: "gāoxìng", indonesianTranslation: "senang", imageRef: "face.smiling", audioRef: "gaoxing"),
                            Flashcard(hanzi: "很", pinyin: "hěn", indonesianTranslation: "sangat", imageRef: "exclamationmark.3", audioRef: "hen"),
                            Flashcard(hanzi: "也", pinyin: "yě", indonesianTranslation: "juga", imageRef: "plus.square.fill.on.square.fill", audioRef: "ye"),
                            Flashcard(hanzi: "朋友", pinyin: "péngyou", indonesianTranslation: "teman", imageRef: "figure.2.arms.open", audioRef: "pengyou"),
                            Flashcard(hanzi: "谁", pinyin: "shéi", indonesianTranslation: "siapa", imageRef: "person.crop.circle.badge.questionmark", audioRef: "shei")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "他是谁？"),
                            DialogLine(speaker: "B", text: "他是我的朋友。"),
                            DialogLine(speaker: "A", text: "很高兴认识你。"),
                            DialogLine(speaker: "B", text: "我也很高兴认识你。")
                        ]
                    ),
                    SubChapter(
                        title: "1.3 Murid atau Guru",
                        flashcards: [
                            Flashcard(hanzi: "老师", pinyin: "lǎoshī", indonesianTranslation: "guru", imageRef: "graduationcap.fill", audioRef: "laoshi"),
                            Flashcard(hanzi: "学生", pinyin: "xuésheng", indonesianTranslation: "murid", imageRef: "book.fill", audioRef: "xuesheng"),
                            Flashcard(hanzi: "不", pinyin: "bù", indonesianTranslation: "tidak / bukan", imageRef: "xmark.circle.fill", audioRef: "bu"),
                            Flashcard(hanzi: "多大", pinyin: "duō dà", indonesianTranslation: "berapa umur", imageRef: "clock.arrow.circlepath", audioRef: "duo da"),
                            Flashcard(hanzi: "今年", pinyin: "jīnnián", indonesianTranslation: "tahun ini", imageRef: "calendar", audioRef: "jinnian"),
                            Flashcard(hanzi: "岁", pinyin: "suì", indonesianTranslation: "tahun (usia)", imageRef: "birthday.cake.fill", audioRef: "sui")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "你是老师吗？"),
                            DialogLine(speaker: "B", text: "不，我是学生。"),
                            DialogLine(speaker: "A", text: "你今年多大？"),
                            DialogLine(speaker: "B", text: "我今年十八岁。")
                        ]
                    )
                ]
            ),
            Course(
                title: "Bab 2: Asal Negara",
                description: "Belajar menanyakan asal negara, bahasa, dan kota tempat tinggal.",
                icon: "book.fill",
                subChapters: [
                    SubChapter(
                        title: "2.1 Dari Negara Mana",
                        flashcards: [
                            Flashcard(hanzi: "哪", pinyin: "nǎ", indonesianTranslation: "mana", imageRef: "map.fill", audioRef: "na"),
                            Flashcard(hanzi: "国", pinyin: "guó", indonesianTranslation: "negara", imageRef: "globe", audioRef: "guo"),
                            Flashcard(hanzi: "人", pinyin: "rén", indonesianTranslation: "orang", imageRef: "person.fill", audioRef: "ren"),
                            Flashcard(hanzi: "中国", pinyin: "Zhōngguó", indonesianTranslation: "Tiongkok", imageRef: "flag.fill", audioRef: "zhongguo"),
                            Flashcard(hanzi: "印尼", pinyin: "Yìnní", indonesianTranslation: "Indonesia", imageRef: "flag.fill", audioRef: "yinni"),
                            Flashcard(hanzi: "来", pinyin: "lái", indonesianTranslation: "datang / berasal", imageRef: "arrow.down.right.circle.fill", audioRef: "lai")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "你是哪国人？"),
                            DialogLine(speaker: "B", text: "我是中国人。"),
                            DialogLine(speaker: "A", text: "我是印尼人。你从哪里来？"),
                            DialogLine(speaker: "B", text: "我从北京来。")
                        ]
                    ),
                    SubChapter(
                        title: "2.2 Negara Lain",
                        flashcards: [
                            Flashcard(hanzi: "美国", pinyin: "Měiguó", indonesianTranslation: "Amerika Serikat", imageRef: "flag.fill", audioRef: "meiguo"),
                            Flashcard(hanzi: "日本", pinyin: "Rìběn", indonesianTranslation: "Jepang", imageRef: "flag.fill", audioRef: "riben"),
                            Flashcard(hanzi: "英国", pinyin: "Yīngguó", indonesianTranslation: "Inggris", imageRef: "flag.fill", audioRef: "yingguo"),
                            Flashcard(hanzi: "他们", pinyin: "tāmen", indonesianTranslation: "mereka", imageRef: "person.3.fill", audioRef: "tamen"),
                            Flashcard(hanzi: "对", pinyin: "duì", indonesianTranslation: "benar/ya", imageRef: "checkmark.circle.fill", audioRef: "dui")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "他是美国人吗？"),
                            DialogLine(speaker: "B", text: "不是，他是日本人。"),
                            DialogLine(speaker: "A", text: "他们是英国人吗？"),
                            DialogLine(speaker: "B", text: "对，他们是英国人。")
                        ]
                    ),
                    SubChapter(
                        title: "2.3 Bahasa & Kota",
                        flashcards: [
                            Flashcard(hanzi: "会", pinyin: "huì", indonesianTranslation: "bisa", imageRef: "lightbulb.fill", audioRef: "hui"),
                            Flashcard(hanzi: "说", pinyin: "shuō", indonesianTranslation: "berbicara", imageRef: "bubble.left.fill", audioRef: "shuo"),
                            Flashcard(hanzi: "汉语", pinyin: "Hànyǔ", indonesianTranslation: "bahasa Mandarin", imageRef: "character.bubble.fill", audioRef: "hanyu"),
                            Flashcard(hanzi: "一点儿", pinyin: "yìdiǎnr", indonesianTranslation: "sedikit", imageRef: "hand.point.up.left.fill", audioRef: "yidianr"),
                            Flashcard(hanzi: "住", pinyin: "zhù", indonesianTranslation: "tinggal", imageRef: "house.fill", audioRef: "zhu"),
                            Flashcard(hanzi: "城市", pinyin: "chéngshì", indonesianTranslation: "kota", imageRef: "building.2.fill", audioRef: "chengshi")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "你会说汉语吗？"),
                            DialogLine(speaker: "B", text: "我会说一点儿。"),
                            DialogLine(speaker: "A", text: "你住在哪个城市？"),
                            DialogLine(speaker: "B", text: "我住在上海。")
                        ]
                    )
                ]
            )
        ]
    }
}
