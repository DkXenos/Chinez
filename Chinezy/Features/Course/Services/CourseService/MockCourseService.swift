import Foundation

class MockCourseService: CourseService {

    public func fetchCourses() -> [Course] {
        [
            Course(
                title: "Bab 1: Perkenalan Diri",
                description: "Belajar menyapa, berkenalan, dan menanyakan umur atau profesi.",
                icon: "你",
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
                            Flashcard(hanzi: "多大", pinyin: "duō dà", indonesianTranslation: "berapa umur", imageRef: "clock.arrow.circlepath", audioRef: "duo_da"),
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
                icon: "国",
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
            ),
            Course(
                title: "Bab 3: Angka",
                description: "Belajar menghitung 1-10, menanyakan jumlah, dan nomor telepon.",
                icon: "数",
                subChapters: [
                    SubChapter(
                        title: "3.1 Angka 1–10",
                        flashcards: [
                            Flashcard(hanzi: "一", pinyin: "yī", indonesianTranslation: "satu", imageRef: "1.circle", audioRef: "yi"),
                            Flashcard(hanzi: "二", pinyin: "èr", indonesianTranslation: "dua", imageRef: "2.circle", audioRef: "er"),
                            Flashcard(hanzi: "三", pinyin: "sān", indonesianTranslation: "tiga", imageRef: "3.circle", audioRef: "san"),
                            Flashcard(hanzi: "四", pinyin: "sì", indonesianTranslation: "empat", imageRef: "4.circle", audioRef: "si"),
                            Flashcard(hanzi: "五", pinyin: "wǔ", indonesianTranslation: "lima", imageRef: "5.circle", audioRef: "wu"),
                            Flashcard(hanzi: "六", pinyin: "liù", indonesianTranslation: "enam", imageRef: "6.circle", audioRef: "liu"),
                            Flashcard(hanzi: "七", pinyin: "qī", indonesianTranslation: "tujuh", imageRef: "7.circle", audioRef: "qi"),
                            Flashcard(hanzi: "八", pinyin: "bā", indonesianTranslation: "delapan", imageRef: "8.circle", audioRef: "ba"),
                            Flashcard(hanzi: "九", pinyin: "jiǔ", indonesianTranslation: "sembilan", imageRef: "9.circle", audioRef: "jiu"),
                            Flashcard(hanzi: "十", pinyin: "shí", indonesianTranslation: "sepuluh", imageRef: "10.circle", audioRef: "shi")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "你会数数吗？"),
                            DialogLine(speaker: "B", text: "会，一、二、三、四、五。"),
                            DialogLine(speaker: "A", text: "六、七、八、九、十。"),
                            DialogLine(speaker: "B", text: "太好了！")
                        ]
                    ),
                    SubChapter(
                        title: "3.2 Berhitung Jumlah",
                        flashcards: [
                            Flashcard(hanzi: "有", pinyin: "yǒu", indonesianTranslation: "ada / punya", imageRef: "hand.raised.fill", audioRef: "you"),
                            Flashcard(hanzi: "多少", pinyin: "duōshao", indonesianTranslation: "berapa (jumlah)", imageRef: "questionmark.circle.fill", audioRef: "duoshao"),
                            Flashcard(hanzi: "个", pinyin: "gè", indonesianTranslation: "(kata bantu bilangan)", imageRef: "number.circle.fill", audioRef: "ge"),
                            Flashcard(hanzi: "十一", pinyin: "shíyī", indonesianTranslation: "sebelas", imageRef: "11.circle", audioRef: "shiyi"),
                            Flashcard(hanzi: "二十", pinyin: "èrshí", indonesianTranslation: "dua puluh", imageRef: "20.circle", audioRef: "ershi"),
                            Flashcard(hanzi: "一百", pinyin: "yìbǎi", indonesianTranslation: "seratus", imageRef: "100.circle", audioRef: "yibai")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "这里有多少人？"),
                            DialogLine(speaker: "B", text: "有二十个人。"),
                            DialogLine(speaker: "A", text: "那里有多少？"),
                            DialogLine(speaker: "B", text: "有一百个。")
                        ]
                    ),
                    SubChapter(
                        title: "3.3 Nomor Telepon",
                        flashcards: [
                            Flashcard(hanzi: "零", pinyin: "líng", indonesianTranslation: "nol", imageRef: "0.circle", audioRef: "ling"),
                            Flashcard(hanzi: "电话", pinyin: "diànhuà", indonesianTranslation: "telepon", imageRef: "phone.fill", audioRef: "dianhua"),
                            Flashcard(hanzi: "号码", pinyin: "hàomǎ", indonesianTranslation: "nomor", imageRef: "number", audioRef: "haoma"),
                            Flashcard(hanzi: "的", pinyin: "de", indonesianTranslation: "(partikel kepemilikan)", imageRef: "tag.fill", audioRef: "de"),
                            Flashcard(hanzi: "好的", pinyin: "hǎo de", indonesianTranslation: "baiklah", imageRef: "hand.thumbsup.fill", audioRef: "hao_de")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "你的电话号码是多少？"),
                            DialogLine(speaker: "B", text: "我的号码是一三八零零……"),
                            DialogLine(speaker: "A", text: "好的，谢谢。"),
                            DialogLine(speaker: "B", text: "不客气。")
                        ]
                    )
                ]
            ),
            Course(
                title: "Bab 4: Keluarga",
                description: "Belajar anggota keluarga inti, keluarga besar, dan anak.",
                icon: "家",
                subChapters: [
                    SubChapter(
                        title: "4.1 Anggota Inti",
                        flashcards: [
                            Flashcard(hanzi: "爸爸", pinyin: "bàba", indonesianTranslation: "ayah", imageRef: "figure.stand", audioRef: "baba"),
                            Flashcard(hanzi: "妈妈", pinyin: "māma", indonesianTranslation: "ibu", imageRef: "figure.dress.line.vertical.figure", audioRef: "mama"),
                            Flashcard(hanzi: "哥哥", pinyin: "gēge", indonesianTranslation: "kakak laki-laki", imageRef: "person.fill", audioRef: "gege"),
                            Flashcard(hanzi: "姐姐", pinyin: "jiějie", indonesianTranslation: "kakak perempuan", imageRef: "person.fill", audioRef: "jiejie"),
                            Flashcard(hanzi: "弟弟", pinyin: "dìdi", indonesianTranslation: "adik laki-laki", imageRef: "person", audioRef: "didi"),
                            Flashcard(hanzi: "妹妹", pinyin: "mèimei", indonesianTranslation: "adik perempuan", imageRef: "person", audioRef: "meimei")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "这是你的爸爸吗？"),
                            DialogLine(speaker: "B", text: "对，这是我爸爸和妈妈。"),
                            DialogLine(speaker: "A", text: "你有哥哥吗？"),
                            DialogLine(speaker: "B", text: "我有一个姐姐和一个弟弟。")
                        ]
                    ),
                    SubChapter(
                        title: "4.2 Keluarga Besar",
                        flashcards: [
                            Flashcard(hanzi: "爷爷", pinyin: "yéye", indonesianTranslation: "kakek (dari ayah)", imageRef: "person.fill.badge.plus", audioRef: "yeye"),
                            Flashcard(hanzi: "奶奶", pinyin: "nǎinai", indonesianTranslation: "nenek (dari ayah)", imageRef: "person.fill.badge.minus", audioRef: "nainai"),
                            Flashcard(hanzi: "家", pinyin: "jiā", indonesianTranslation: "rumah / keluarga", imageRef: "house.fill", audioRef: "jia"),
                            Flashcard(hanzi: "几", pinyin: "jǐ", indonesianTranslation: "berapa (sedikit)", imageRef: "questionmark", audioRef: "ji"),
                            Flashcard(hanzi: "口", pinyin: "kǒu", indonesianTranslation: "(kata bantu org keluarga)", imageRef: "person.3.sequence.fill", audioRef: "kou"),
                            Flashcard(hanzi: "我们", pinyin: "wǒmen", indonesianTranslation: "kami / kita", imageRef: "person.3.fill", audioRef: "women")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "你家有几口人？"),
                            DialogLine(speaker: "B", text: "我家有五口人。"),
                            DialogLine(speaker: "A", text: "有爷爷奶奶吗？"),
                            DialogLine(speaker: "B", text: "有，爷爷奶奶和我们一起住。")
                        ]
                    ),
                    SubChapter(
                        title: "4.3 Anak",
                        flashcards: [
                            Flashcard(hanzi: "孩子", pinyin: "háizi", indonesianTranslation: "anak", imageRef: "figure.child", audioRef: "haizi"),
                            Flashcard(hanzi: "儿子", pinyin: "érzi", indonesianTranslation: "anak laki-laki", imageRef: "figure.child.circle", audioRef: "erzi"),
                            Flashcard(hanzi: "女儿", pinyin: "nǚ'ér", indonesianTranslation: "anak perempuan", imageRef: "figure.child.circle.fill", audioRef: "nuer"),
                            Flashcard(hanzi: "没有", pinyin: "méiyǒu", indonesianTranslation: "tidak punya", imageRef: "xmark.circle", audioRef: "meiyou"),
                            Flashcard(hanzi: "爱", pinyin: "ài", indonesianTranslation: "cinta / sayang", imageRef: "heart.fill", audioRef: "ai")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "你有孩子吗？"),
                            DialogLine(speaker: "B", text: "有，一个儿子和一个女儿。"),
                            DialogLine(speaker: "A", text: "我还没有孩子。"),
                            DialogLine(speaker: "B", text: "我很爱我的孩子。")
                        ]
                    )
                ]
            ),
            Course(
                title: "Bab 5: Hobi",
                description: "Belajar kosakata tentang hobi, olahraga ringan, dan kegiatan akhir pekan.",
                icon: "喜",
                subChapters: [
                    SubChapter(
                        title: "5.1 Suka Melakukan Apa",
                        flashcards: [
                            Flashcard(hanzi: "喜欢", pinyin: "xǐhuan", indonesianTranslation: "suka", imageRef: "heart.fill", audioRef: "xihuan"),
                            Flashcard(hanzi: "看", pinyin: "kàn", indonesianTranslation: "melihat / menonton", imageRef: "eye.fill", audioRef: "kan"),
                            Flashcard(hanzi: "书", pinyin: "shū", indonesianTranslation: "buku", imageRef: "book.fill", audioRef: "shu"),
                            Flashcard(hanzi: "电影", pinyin: "diànyǐng", indonesianTranslation: "film", imageRef: "film.fill", audioRef: "dianying"),
                            Flashcard(hanzi: "听", pinyin: "tīng", indonesianTranslation: "mendengar", imageRef: "ear.fill", audioRef: "ting"),
                            Flashcard(hanzi: "音乐", pinyin: "yīnyuè", indonesianTranslation: "musik", imageRef: "music.note", audioRef: "yinyue")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "你喜欢做什么？"),
                            DialogLine(speaker: "B", text: "我喜欢看书和看电影。"),
                            DialogLine(speaker: "A", text: "你喜欢听音乐吗？"),
                            DialogLine(speaker: "B", text: "喜欢，我很喜欢音乐。")
                        ]
                    ),
                    SubChapter(
                        title: "5.2 Olahraga Ringan",
                        flashcards: [
                            Flashcard(hanzi: "运动", pinyin: "yùndòng", indonesianTranslation: "olahraga", imageRef: "figure.run", audioRef: "yundong"),
                            Flashcard(hanzi: "游泳", pinyin: "yóuyǒng", indonesianTranslation: "berenang", imageRef: "figure.pool.swim", audioRef: "youyong"),
                            Flashcard(hanzi: "跑步", pinyin: "pǎobù", indonesianTranslation: "lari", imageRef: "figure.run", audioRef: "paobu"),
                            Flashcard(hanzi: "打球", pinyin: "dǎqiú", indonesianTranslation: "main bola", imageRef: "basketball.fill", audioRef: "daqiu")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "你喜欢运动吗？"),
                            DialogLine(speaker: "B", text: "喜欢，我喜欢游泳和跑步。"),
                            DialogLine(speaker: "A", text: "你会打球吗？"),
                            DialogLine(speaker: "B", text: "会一点儿。")
                        ]
                    ),
                    SubChapter(
                        title: "5.3 Akhir Pekan",
                        flashcards: [
                            Flashcard(hanzi: "周末", pinyin: "zhōumò", indonesianTranslation: "akhir pekan", imageRef: "calendar", audioRef: "zhoumo"),
                            Flashcard(hanzi: "唱歌", pinyin: "chànggē", indonesianTranslation: "menyanyi", imageRef: "music.mic", audioRef: "changge"),
                            Flashcard(hanzi: "跳舞", pinyin: "tiàowǔ", indonesianTranslation: "menari", imageRef: "figure.dance", audioRef: "tiaowu"),
                            Flashcard(hanzi: "画画", pinyin: "huàhuà", indonesianTranslation: "menggambar", imageRef: "paintbrush.fill", audioRef: "huahua"),
                            Flashcard(hanzi: "旅游", pinyin: "lǚyóu", indonesianTranslation: "berwisata", imageRef: "airplane", audioRef: "luyou"),
                            Flashcard(hanzi: "一起", pinyin: "yìqǐ", indonesianTranslation: "bersama", imageRef: "person.2.fill", audioRef: "yiqi")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "你周末做什么？"),
                            DialogLine(speaker: "B", text: "我喜欢唱歌和跳舞。"),
                            DialogLine(speaker: "A", text: "我们一起去旅游吧。"),
                            DialogLine(speaker: "B", text: "好啊！")
                        ]
                    )
                ]
            ),
            Course(
                title: "Bab 6: Waktu",
                description: "Belajar tentang hari, jam, bulan, dan tahun.",
                icon: "时",
                subChapters: [
                    SubChapter(
                        title: "6.1 Hari",
                        flashcards: [
                            Flashcard(hanzi: "今天", pinyin: "jīntiān", indonesianTranslation: "hari ini", imageRef: "calendar.badge.clock", audioRef: "jintian"),
                            Flashcard(hanzi: "明天", pinyin: "míngtiān", indonesianTranslation: "besok", imageRef: "arrow.right.to.line.alt", audioRef: "mingtian"),
                            Flashcard(hanzi: "昨天", pinyin: "zuótiān", indonesianTranslation: "kemarin", imageRef: "arrow.left.to.line.alt", audioRef: "zuotian"),
                            Flashcard(hanzi: "星期", pinyin: "xīngqī", indonesianTranslation: "minggu / hari", imageRef: "calendar", audioRef: "xingqi"),
                            Flashcard(hanzi: "星期一", pinyin: "xīngqīyī", indonesianTranslation: "Senin", imageRef: "1.square.fill", audioRef: "xingqiyi"),
                            Flashcard(hanzi: "星期天", pinyin: "xīngqītiān", indonesianTranslation: "Minggu", imageRef: "7.square.fill", audioRef: "xingqitian")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "今天星期几？"),
                            DialogLine(speaker: "B", text: "今天星期一。"),
                            DialogLine(speaker: "A", text: "明天星期几？"),
                            DialogLine(speaker: "B", text: "明天星期二。")
                        ]
                    ),
                    SubChapter(
                        title: "6.2 Jam",
                        flashcards: [
                            Flashcard(hanzi: "现在", pinyin: "xiànzài", indonesianTranslation: "sekarang", imageRef: "clock.fill", audioRef: "xianzai"),
                            Flashcard(hanzi: "点", pinyin: "diǎn", indonesianTranslation: "pukul (jam)", imageRef: "clock", audioRef: "dian"),
                            Flashcard(hanzi: "分", pinyin: "fēn", indonesianTranslation: "menit", imageRef: "timer", audioRef: "fen"),
                            Flashcard(hanzi: "半", pinyin: "bàn", indonesianTranslation: "setengah", imageRef: "circle.lefthalf.filled", audioRef: "ban"),
                            Flashcard(hanzi: "早上", pinyin: "zǎoshang", indonesianTranslation: "pagi", imageRef: "sunrise.fill", audioRef: "zaoshang"),
                            Flashcard(hanzi: "晚上", pinyin: "wǎnshang", indonesianTranslation: "malam", imageRef: "moon.stars.fill", audioRef: "wanshang")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "现在几点？"),
                            DialogLine(speaker: "B", text: "现在八点半。"),
                            DialogLine(speaker: "A", text: "你早上几点起床？"),
                            DialogLine(speaker: "B", text: "我六点起床。")
                        ]
                    ),
                    SubChapter(
                        title: "6.3 Bulan & Tahun",
                        flashcards: [
                            Flashcard(hanzi: "月", pinyin: "yuè", indonesianTranslation: "bulan", imageRef: "calendar", audioRef: "yue"),
                            Flashcard(hanzi: "号", pinyin: "hào", indonesianTranslation: "tanggal", imageRef: "number.circle.fill", audioRef: "hao"),
                            Flashcard(hanzi: "年", pinyin: "nián", indonesianTranslation: "tahun", imageRef: "calendar.circle.fill", audioRef: "nian"),
                            Flashcard(hanzi: "生日", pinyin: "shēngrì", indonesianTranslation: "ulang tahun", imageRef: "birthday.cake.fill", audioRef: "shengri")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "你的生日是几月几号？"),
                            DialogLine(speaker: "B", text: "我的生日是五月十号。"),
                            DialogLine(speaker: "A", text: "今年是哪一年？"),
                            DialogLine(speaker: "B", text: "今年是二零二六年。")
                        ]
                    )
                ]
            ),
            Course(
                title: "Bab 7: Makanan dan Minuman",
                description: "Belajar kosakata makanan pokok, minuman, buah, dan rasa.",
                icon: "食",
                subChapters: [
                    SubChapter(
                        title: "7.1 Makanan Pokok",
                        flashcards: [
                            Flashcard(hanzi: "吃", pinyin: "chī", indonesianTranslation: "makan", imageRef: "fork.knife", audioRef: "chi"),
                            Flashcard(hanzi: "饿", pinyin: "è", indonesianTranslation: "lapar", imageRef: "face.dashed", audioRef: "e"),
                            Flashcard(hanzi: "米饭", pinyin: "mǐfàn", indonesianTranslation: "nasi", imageRef: "takeoutbox.fill", audioRef: "mifan"),
                            Flashcard(hanzi: "面条", pinyin: "miàntiáo", indonesianTranslation: "mie", imageRef: "fork.knife.circle", audioRef: "miantiao"),
                            Flashcard(hanzi: "鸡蛋", pinyin: "jīdàn", indonesianTranslation: "telur", imageRef: "oval.fill", audioRef: "jidan"),
                            Flashcard(hanzi: "面包", pinyin: "miànbāo", indonesianTranslation: "roti", imageRef: "square.fill", audioRef: "mianbao")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "你饿吗？"),
                            DialogLine(speaker: "B", text: "我很饿，想吃米饭。"),
                            DialogLine(speaker: "A", text: "我想吃面条和鸡蛋。"),
                            DialogLine(speaker: "B", text: "我们去吃饭吧。")
                        ]
                    ),
                    SubChapter(
                        title: "7.2 Minuman",
                        flashcards: [
                            Flashcard(hanzi: "喝", pinyin: "hē", indonesianTranslation: "minum", imageRef: "cup.and.saucer.fill", audioRef: "he"),
                            Flashcard(hanzi: "渴", pinyin: "kě", indonesianTranslation: "haus", imageRef: "drop.triangle", audioRef: "ke"),
                            Flashcard(hanzi: "水", pinyin: "shuǐ", indonesianTranslation: "air", imageRef: "drop.fill", audioRef: "shui"),
                            Flashcard(hanzi: "茶", pinyin: "chá", indonesianTranslation: "teh", imageRef: "leaf.fill", audioRef: "cha"),
                            Flashcard(hanzi: "咖啡", pinyin: "kāfēi", indonesianTranslation: "kopi", imageRef: "cup.and.saucer.fill", audioRef: "kafei"),
                            Flashcard(hanzi: "牛奶", pinyin: "niúnǎi", indonesianTranslation: "susu", imageRef: "mug.fill", audioRef: "niunai")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "你渴吗？"),
                            DialogLine(speaker: "B", text: "渴，我想喝水。"),
                            DialogLine(speaker: "A", text: "你喝茶还是喝咖啡？"),
                            DialogLine(speaker: "B", text: "我喝咖啡，谢谢。")
                        ]
                    ),
                    SubChapter(
                        title: "7.3 Buah & Rasa",
                        flashcards: [
                            Flashcard(hanzi: "水果", pinyin: "shuǐguǒ", indonesianTranslation: "buah", imageRef: "applelogo", audioRef: "shuiguo"),
                            Flashcard(hanzi: "苹果", pinyin: "píngguǒ", indonesianTranslation: "apel", imageRef: "apple.logo", audioRef: "pingguo"),
                            Flashcard(hanzi: "香蕉", pinyin: "xiāngjiāo", indonesianTranslation: "pisang", imageRef: "leaf.arrow.triangle.circlepath", audioRef: "xiangjiao"),
                            Flashcard(hanzi: "好吃", pinyin: "hǎochī", indonesianTranslation: "enak (makanan)", imageRef: "hand.thumbsup.fill", audioRef: "haochi"),
                            Flashcard(hanzi: "甜", pinyin: "tián", indonesianTranslation: "manis", imageRef: "face.smiling", audioRef: "tian")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "你喜欢吃水果吗？"),
                            DialogLine(speaker: "B", text: "喜欢，我喜欢苹果和香蕉。"),
                            DialogLine(speaker: "A", text: "苹果好吃吗？"),
                            DialogLine(speaker: "B", text: "很好吃，很甜。")
                        ]
                    )
                ]
            ),
            Course(
                title: "Bab 8: Binatang",
                description: "Belajar tentang hewan peliharaan, hewan ternak, dan kebun binatang.",
                icon: "动",
                subChapters: [
                    SubChapter(
                        title: "8.1 Hewan Peliharaan",
                        flashcards: [
                            Flashcard(hanzi: "动物", pinyin: "dòngwù", indonesianTranslation: "hewan", imageRef: "pawprint.fill", audioRef: "dongwu"),
                            Flashcard(hanzi: "狗", pinyin: "gǒu", indonesianTranslation: "anjing", imageRef: "dog.fill", audioRef: "gou"),
                            Flashcard(hanzi: "猫", pinyin: "māo", indonesianTranslation: "kucing", imageRef: "cat.fill", audioRef: "mao"),
                            Flashcard(hanzi: "鱼", pinyin: "yú", indonesianTranslation: "ikan", imageRef: "fish.fill", audioRef: "yu"),
                            Flashcard(hanzi: "鸟", pinyin: "niǎo", indonesianTranslation: "burung", imageRef: "bird.fill", audioRef: "niao"),
                            Flashcard(hanzi: "可爱", pinyin: "kě'ài", indonesianTranslation: "lucu / imut", imageRef: "heart.fill", audioRef: "keai")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "你家有动物吗？"),
                            DialogLine(speaker: "B", text: "有，我有一只狗和一只猫。"),
                            DialogLine(speaker: "A", text: "它们很可爱。"),
                            DialogLine(speaker: "B", text: "对，我很喜欢它们。")
                        ]
                    ),
                    SubChapter(
                        title: "8.2 Hewan Ternak",
                        flashcards: [
                            Flashcard(hanzi: "马", pinyin: "mǎ", indonesianTranslation: "kuda", imageRef: "tortoise.fill", audioRef: "ma"),
                            Flashcard(hanzi: "牛", pinyin: "niú", indonesianTranslation: "sapi", imageRef: "hare.fill", audioRef: "niu"),
                            Flashcard(hanzi: "羊", pinyin: "yáng", indonesianTranslation: "kambing / domba", imageRef: "ant.fill", audioRef: "yang"),
                            Flashcard(hanzi: "鸡", pinyin: "jī", indonesianTranslation: "ayam", imageRef: "bird", audioRef: "ji"),
                            Flashcard(hanzi: "大", pinyin: "dà", indonesianTranslation: "besar", imageRef: "arrow.up.left.and.arrow.down.right", audioRef: "da"),
                            Flashcard(hanzi: "小", pinyin: "xiǎo", indonesianTranslation: "kecil", imageRef: "arrow.down.right.and.arrow.up.left", audioRef: "xiao")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "那是什么动物？"),
                            DialogLine(speaker: "B", text: "那是马，很大。"),
                            DialogLine(speaker: "A", text: "这只羊很小。"),
                            DialogLine(speaker: "B", text: "对，旁边有牛和鸡。")
                        ]
                    ),
                    SubChapter(
                        title: "8.3 Kebun Binatang",
                        flashcards: [
                            Flashcard(hanzi: "动物园", pinyin: "dòngwùyuán", indonesianTranslation: "kebun binatang", imageRef: "map.fill", audioRef: "dongwuyuan"),
                            Flashcard(hanzi: "熊猫", pinyin: "xióngmāo", indonesianTranslation: "panda", imageRef: "pawprint", audioRef: "xiongmao"),
                            Flashcard(hanzi: "老虎", pinyin: "lǎohǔ", indonesianTranslation: "harimau", imageRef: "pawprint.circle", audioRef: "laohu"),
                            Flashcard(hanzi: "大象", pinyin: "dàxiàng", indonesianTranslation: "gajah", imageRef: "ear", audioRef: "daxiang"),
                            Flashcard(hanzi: "猴子", pinyin: "hóuzi", indonesianTranslation: "monyet", imageRef: "figure.climbing", audioRef: "houzi")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "周末我们去动物园吧。"),
                            DialogLine(speaker: "B", text: "好！我想看熊猫。"),
                            DialogLine(speaker: "A", text: "那里有老虎和大象吗？"),
                            DialogLine(speaker: "B", text: "有，还有猴子。")
                        ]
                    )
                ]
            ),
            Course(
                title: "Bab 9: Warna",
                description: "Belajar warna dasar, warna pakaian, dan perbedaan warna tua-muda.",
                icon: "色",
                subChapters: [
                    SubChapter(
                        title: "9.1 Warna Dasar",
                        flashcards: [
                            Flashcard(hanzi: "颜色", pinyin: "yánsè", indonesianTranslation: "warna", imageRef: "paintpalette.fill", audioRef: "yanse"),
                            Flashcard(hanzi: "红色", pinyin: "hóngsè", indonesianTranslation: "merah", imageRef: "circle.fill", audioRef: "hongse"),
                            Flashcard(hanzi: "蓝色", pinyin: "lánsè", indonesianTranslation: "biru", imageRef: "circle.fill", audioRef: "lanse"),
                            Flashcard(hanzi: "黄色", pinyin: "huángsè", indonesianTranslation: "kuning", imageRef: "circle.fill", audioRef: "huangse"),
                            Flashcard(hanzi: "绿色", pinyin: "lǜsè", indonesianTranslation: "hijau", imageRef: "circle.fill", audioRef: "luse")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "你喜欢什么颜色？"),
                            DialogLine(speaker: "B", text: "我喜欢红色和蓝色。"),
                            DialogLine(speaker: "A", text: "这个是黄色还是绿色？"),
                            DialogLine(speaker: "B", text: "是绿色。")
                        ]
                    ),
                    SubChapter(
                        title: "9.2 Warna Pakaian",
                        flashcards: [
                            Flashcard(hanzi: "衣服", pinyin: "yīfu", indonesianTranslation: "baju", imageRef: "tshirt.fill", audioRef: "yifu"),
                            Flashcard(hanzi: "黑色", pinyin: "hēisè", indonesianTranslation: "hitam", imageRef: "square.fill", audioRef: "heise"),
                            Flashcard(hanzi: "白色", pinyin: "báisè", indonesianTranslation: "putih", imageRef: "square", audioRef: "baise"),
                            Flashcard(hanzi: "粉色", pinyin: "fěnsè", indonesianTranslation: "merah muda", imageRef: "heart.circle.fill", audioRef: "fense"),
                            Flashcard(hanzi: "漂亮", pinyin: "piàoliang", indonesianTranslation: "cantik / indah", imageRef: "sparkles", audioRef: "piaoliang")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "你的衣服是什么颜色？"),
                            DialogLine(speaker: "B", text: "是黑色的。"),
                            DialogLine(speaker: "A", text: "这件白色的很漂亮。"),
                            DialogLine(speaker: "B", text: "我也喜欢粉色。")
                        ]
                    ),
                    SubChapter(
                        title: "9.3 Warna Tua & Muda",
                        flashcards: [
                            Flashcard(hanzi: "天", pinyin: "tiān", indonesianTranslation: "langit", imageRef: "cloud.fill", audioRef: "tian"),
                            Flashcard(hanzi: "橙色", pinyin: "chéngsè", indonesianTranslation: "oranye", imageRef: "circle.fill", audioRef: "chengse"),
                            Flashcard(hanzi: "灰色", pinyin: "huīsè", indonesianTranslation: "abu-abu", imageRef: "circle.fill", audioRef: "huise"),
                            Flashcard(hanzi: "深", pinyin: "shēn", indonesianTranslation: "tua / gelap (warna)", imageRef: "circle.lefthalf.filled", audioRef: "shen"),
                            Flashcard(hanzi: "浅", pinyin: "qiǎn", indonesianTranslation: "muda / terang (warna)", imageRef: "circle.righthalf.filled", audioRef: "qian")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "天是什么颜色？"),
                            DialogLine(speaker: "B", text: "天是蓝色的。"),
                            DialogLine(speaker: "A", text: "我喜欢深蓝色。"),
                            DialogLine(speaker: "B", text: "我喜欢浅一点儿的。")
                        ]
                    )
                ]
            ),
            Course(
                title: "Bab 10: Benda-Benda di Sekitar",
                description: "Belajar kosakata alat belajar, barang pribadi, dan posisi benda.",
                icon: "物",
                subChapters: [
                    SubChapter(
                        title: "10.1 Alat Belajar",
                        flashcards: [
                            Flashcard(hanzi: "笔", pinyin: "bǐ", indonesianTranslation: "pena / pulpen", imageRef: "pencil", audioRef: "bi"),
                            Flashcard(hanzi: "本子", pinyin: "běnzi", indonesianTranslation: "buku tulis", imageRef: "book.closed.fill", audioRef: "benzi"),
                            Flashcard(hanzi: "桌子", pinyin: "zhuōzi", indonesianTranslation: "meja", imageRef: "table.furniture.fill", audioRef: "zhuozi"),
                            Flashcard(hanzi: "椅子", pinyin: "yǐzi", indonesianTranslation: "kursi", imageRef: "chair.lounge.fill", audioRef: "yizi"),
                            Flashcard(hanzi: "电脑", pinyin: "diànnǎo", indonesianTranslation: "komputer", imageRef: "laptopcomputer", audioRef: "diannao")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "桌子上有什么？"),
                            DialogLine(speaker: "B", text: "有一支笔和一个本子。"),
                            DialogLine(speaker: "A", text: "你的电脑在哪儿？"),
                            DialogLine(speaker: "B", text: "在椅子旁边。")
                        ]
                    ),
                    SubChapter(
                        title: "10.2 Barang Pribadi",
                        flashcards: [
                            Flashcard(hanzi: "手机", pinyin: "shǒujī", indonesianTranslation: "HP / ponsel", imageRef: "iphone", audioRef: "shouji"),
                            Flashcard(hanzi: "钱", pinyin: "qián", indonesianTranslation: "uang", imageRef: "banknote.fill", audioRef: "qian"),
                            Flashcard(hanzi: "包", pinyin: "bāo", indonesianTranslation: "tas", imageRef: "bag.fill", audioRef: "bao"),
                            Flashcard(hanzi: "钥匙", pinyin: "yàoshi", indonesianTranslation: "kunci", imageRef: "key.fill", audioRef: "yaoshi"),
                            Flashcard(hanzi: "眼镜", pinyin: "yǎnjìng", indonesianTranslation: "kacamata", imageRef: "eyeglasses", audioRef: "yanjing")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "我的手机在哪里？"),
                            DialogLine(speaker: "B", text: "在你的包里。"),
                            DialogLine(speaker: "A", text: "我的钥匙和眼镜呢？"),
                            DialogLine(speaker: "B", text: "在桌子上。")
                        ]
                    ),
                    SubChapter(
                        title: "10.3 Posisi Benda",
                        flashcards: [
                            Flashcard(hanzi: "在", pinyin: "zài", indonesianTranslation: "berada di", imageRef: "mappin.and.ellipse", audioRef: "zai"),
                            Flashcard(hanzi: "上面", pinyin: "shàngmiàn", indonesianTranslation: "(di) atas", imageRef: "arrow.up.square.fill", audioRef: "shangmian"),
                            Flashcard(hanzi: "下面", pinyin: "xiàmiàn", indonesianTranslation: "(di) bawah", imageRef: "arrow.down.square.fill", audioRef: "xiamian"),
                            Flashcard(hanzi: "里面", pinyin: "lǐmiàn", indonesianTranslation: "(di) dalam", imageRef: "shippingbox.fill", audioRef: "limian"),
                            Flashcard(hanzi: "旁边", pinyin: "pángbiān", indonesianTranslation: "(di) sebelah", imageRef: "rectangle.split.2x1.fill", audioRef: "pangbian")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "猫在哪里？"),
                            DialogLine(speaker: "B", text: "在桌子下面。"),
                            DialogLine(speaker: "A", text: "书在椅子上面吗？"),
                            DialogLine(speaker: "B", text: "不，在包里面。")
                        ]
                    )
                ]
            ),
            Course(
                title: "Bab 11: Ruangan dan Tempat",
                description: "Belajar ruangan rumah, tempat umum, dan menanyakan arah jalan.",
                icon: "房",
                subChapters: [
                    SubChapter(
                        title: "11.1 Ruangan Rumah",
                        flashcards: [
                            Flashcard(hanzi: "房间", pinyin: "fángjiān", indonesianTranslation: "kamar / ruangan", imageRef: "door.left.hand.closed", audioRef: "fangjian"),
                            Flashcard(hanzi: "客厅", pinyin: "kètīng", indonesianTranslation: "ruang tamu", imageRef: "sofa.fill", audioRef: "keting"),
                            Flashcard(hanzi: "厨房", pinyin: "chúfáng", indonesianTranslation: "dapur", imageRef: "refrigerator.fill", audioRef: "chufang"),
                            Flashcard(hanzi: "卧室", pinyin: "wòshì", indonesianTranslation: "kamar tidur", imageRef: "bed.double.fill", audioRef: "woshi"),
                            Flashcard(hanzi: "洗手间", pinyin: "xǐshǒujiān", indonesianTranslation: "toilet / kamar mandi", imageRef: "toilet.fill", audioRef: "xishoujian")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "你家有几个房间？"),
                            DialogLine(speaker: "B", text: "有三个，还有客厅和厨房。"),
                            DialogLine(speaker: "A", text: "洗手间在哪里？"),
                            DialogLine(speaker: "B", text: "在卧室旁边。")
                        ]
                    ),
                    SubChapter(
                        title: "11.2 Tempat Umum",
                        flashcards: [
                            Flashcard(hanzi: "学校", pinyin: "xuéxiào", indonesianTranslation: "sekolah", imageRef: "building.columns.fill", audioRef: "xuexiao"),
                            Flashcard(hanzi: "医院", pinyin: "yīyuàn", indonesianTranslation: "rumah sakit", imageRef: "cross.case.fill", audioRef: "yiyuan"),
                            Flashcard(hanzi: "商店", pinyin: "shāngdiàn", indonesianTranslation: "toko", imageRef: "cart.fill", audioRef: "shangdian"),
                            Flashcard(hanzi: "银行", pinyin: "yínháng", indonesianTranslation: "bank", imageRef: "building.columns.fill", audioRef: "yinhang"),
                            Flashcard(hanzi: "饭馆", pinyin: "fànguǎn", indonesianTranslation: "restoran / rumah makan", imageRef: "fork.knife", audioRef: "fanguan")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "你去哪儿？"),
                            DialogLine(speaker: "B", text: "我去学校。"),
                            DialogLine(speaker: "A", text: "医院在商店旁边吗？"),
                            DialogLine(speaker: "B", text: "对，旁边还有银行。")
                        ]
                    ),
                    SubChapter(
                        title: "11.3 Arah Jalan",
                        flashcards: [
                            Flashcard(hanzi: "车站", pinyin: "chēzhàn", indonesianTranslation: "stasiun / halte", imageRef: "bus.fill", audioRef: "chezhan"),
                            Flashcard(hanzi: "走", pinyin: "zǒu", indonesianTranslation: "berjalan", imageRef: "figure.walk", audioRef: "zou"),
                            Flashcard(hanzi: "左", pinyin: "zuǒ", indonesianTranslation: "kiri", imageRef: "arrow.left", audioRef: "zuo"),
                            Flashcard(hanzi: "右", pinyin: "yòu", indonesianTranslation: "kanan", imageRef: "arrow.right", audioRef: "you"),
                            Flashcard(hanzi: "远", pinyin: "yuǎn", indonesianTranslation: "jauh", imageRef: "arrow.up.and.down.and.arrow.left.and.right", audioRef: "yuan"),
                            Flashcard(hanzi: "近", pinyin: "jìn", indonesianTranslation: "dekat", imageRef: "arrow.down.right.and.arrow.up.left", audioRef: "jin")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "去车站怎么走？"),
                            DialogLine(speaker: "B", text: "往前走，在左边。"),
                            DialogLine(speaker: "A", text: "远吗？"),
                            DialogLine(speaker: "B", text: "不远，很近。")
                        ]
                    )
                ]
            ),
            Course(
                title: "Bab 12: Cuaca",
                description: "Belajar kondisi cuaca, suhu, dan musim.",
                icon: "天",
                subChapters: [
                    SubChapter(
                        title: "12.1 Kondisi Cuaca",
                        flashcards: [
                            Flashcard(hanzi: "天气", pinyin: "tiānqì", indonesianTranslation: "cuaca", imageRef: "cloud.sun.fill", audioRef: "tianqi"),
                            Flashcard(hanzi: "怎么样", pinyin: "zěnmeyàng", indonesianTranslation: "bagaimana", imageRef: "questionmark.bubble.fill", audioRef: "zenmeyang"),
                            Flashcard(hanzi: "晴", pinyin: "qíng", indonesianTranslation: "cerah", imageRef: "sun.max.fill", audioRef: "qing"),
                            Flashcard(hanzi: "阴", pinyin: "yīn", indonesianTranslation: "mendung", imageRef: "cloud.fill", audioRef: "yin"),
                            Flashcard(hanzi: "下雨", pinyin: "xiàyǔ", indonesianTranslation: "hujan", imageRef: "cloud.rain.fill", audioRef: "xiayu"),
                            Flashcard(hanzi: "刮风", pinyin: "guāfēng", indonesianTranslation: "berangin", imageRef: "wind", audioRef: "guafeng")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "今天天气怎么样？"),
                            DialogLine(speaker: "B", text: "今天是晴天。"),
                            DialogLine(speaker: "A", text: "明天下雨吗？"),
                            DialogLine(speaker: "B", text: "明天下雨，还刮风。")
                        ]
                    ),
                    SubChapter(
                        title: "12.2 Suhu",
                        flashcards: [
                            Flashcard(hanzi: "热", pinyin: "rè", indonesianTranslation: "panas", imageRef: "thermometer.sun.fill", audioRef: "re"),
                            Flashcard(hanzi: "冷", pinyin: "lěng", indonesianTranslation: "dingin", imageRef: "thermometer.snowflake", audioRef: "leng"),
                            Flashcard(hanzi: "暖和", pinyin: "nuǎnhuo", indonesianTranslation: "hangat", imageRef: "sun.min.fill", audioRef: "nuanhuo"),
                            Flashcard(hanzi: "凉快", pinyin: "liángkuai", indonesianTranslation: "sejuk", imageRef: "wind", audioRef: "liangkuai"),
                            Flashcard(hanzi: "度", pinyin: "dù", indonesianTranslation: "derajat", imageRef: "thermometer", audioRef: "du")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "今天热吗？"),
                            DialogLine(speaker: "B", text: "很热，有三十五度。"),
                            DialogLine(speaker: "A", text: "冬天冷不冷？"),
                            DialogLine(speaker: "B", text: "很冷，要穿很多衣服。")
                        ]
                    ),
                    SubChapter(
                        title: "12.3 Musim",
                        flashcards: [
                            Flashcard(hanzi: "季节", pinyin: "jìjié", indonesianTranslation: "musim", imageRef: "leaf.arrow.triangle.circlepath", audioRef: "jijie"),
                            Flashcard(hanzi: "春天", pinyin: "chūntiān", indonesianTranslation: "musim semi", imageRef: "leaf.fill", audioRef: "chuntian"),
                            Flashcard(hanzi: "夏天", pinyin: "xiàtiān", indonesianTranslation: "musim panas", imageRef: "sun.max.fill", audioRef: "xiatian"),
                            Flashcard(hanzi: "秋天", pinyin: "qiūtiān", indonesianTranslation: "musim gugur", imageRef: "leaf.fill", audioRef: "qiutian"),
                            Flashcard(hanzi: "冬天", pinyin: "dōngtiān", indonesianTranslation: "musim dingin", imageRef: "snowflake", audioRef: "dongtian"),
                            Flashcard(hanzi: "雪", pinyin: "xuě", indonesianTranslation: "salju", imageRef: "snow", audioRef: "xue")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "你喜欢什么季节？"),
                            DialogLine(speaker: "B", text: "我喜欢春天和秋天。"),
                            DialogLine(speaker: "A", text: "冬天会下雪吗？"),
                            DialogLine(speaker: "B", text: "会，冬天很冷。")
                        ]
                    )
                ]
            ),
            Course(
                title: "Bab 13: Jenis Olahraga",
                description: "Belajar olahraga bola, aktivitas fisik, dan pertandingan.",
                icon: "球",
                subChapters: [
                    SubChapter(
                        title: "13.1 Olahraga Bola",
                        flashcards: [
                            Flashcard(hanzi: "篮球", pinyin: "lánqiú", indonesianTranslation: "bola basket", imageRef: "basketball.fill", audioRef: "lanqiu"),
                            Flashcard(hanzi: "足球", pinyin: "zúqiú", indonesianTranslation: "sepak bola", imageRef: "figure.soccer", audioRef: "zuqiu"),
                            Flashcard(hanzi: "网球", pinyin: "wǎngqiú", indonesianTranslation: "tenis", imageRef: "tennis.racket", audioRef: "wangqiu"),
                            Flashcard(hanzi: "乒乓球", pinyin: "pīngpāngqiú", indonesianTranslation: "tenis meja", imageRef: "circle.circle.fill", audioRef: "pingpangqiu"),
                            Flashcard(hanzi: "踢", pinyin: "tī", indonesianTranslation: "menendang", imageRef: "figure.soccer", audioRef: "ti")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "你喜欢什么运动？"),
                            DialogLine(speaker: "B", text: "我喜欢打篮球。"),
                            DialogLine(speaker: "A", text: "你会踢足球吗？"),
                            DialogLine(speaker: "B", text: "会，我也喜欢打乒乓球。")
                        ]
                    ),
                    SubChapter(
                        title: "13.2 Aktivitas Fisik",
                        flashcards: [
                            Flashcard(hanzi: "锻炼", pinyin: "duànliàn", indonesianTranslation: "berlatih / olahraga", imageRef: "figure.run", audioRef: "duanlian"),
                            Flashcard(hanzi: "每天", pinyin: "měitiān", indonesianTranslation: "setiap hari", imageRef: "calendar.badge.clock", audioRef: "meitian"),
                            Flashcard(hanzi: "骑车", pinyin: "qíchē", indonesianTranslation: "bersepeda", imageRef: "bicycle", audioRef: "qiche"),
                            Flashcard(hanzi: "爬山", pinyin: "páshān", indonesianTranslation: "mendaki gunung", imageRef: "figure.hiking", audioRef: "pashan"),
                            Flashcard(hanzi: "健身", pinyin: "jiànshēn", indonesianTranslation: "fitness", imageRef: "dumbbell.fill", audioRef: "jianshen")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "你每天锻炼吗？"),
                            DialogLine(speaker: "B", text: "对，我喜欢跑步和骑车。"),
                            DialogLine(speaker: "A", text: "周末我们去爬山吧。"),
                            DialogLine(speaker: "B", text: "好，我也想去健身。")
                        ]
                    ),
                    SubChapter(
                        title: "13.3 Pertandingan",
                        flashcards: [
                            Flashcard(hanzi: "比赛", pinyin: "bǐsài", indonesianTranslation: "pertandingan", imageRef: "sportscourt.fill", audioRef: "bisai"),
                            Flashcard(hanzi: "队", pinyin: "duì", indonesianTranslation: "tim / regu", imageRef: "person.3.fill", audioRef: "dui"),
                            Flashcard(hanzi: "赢", pinyin: "yíng", indonesianTranslation: "menang", imageRef: "trophy.fill", audioRef: "ying"),
                            Flashcard(hanzi: "输", pinyin: "shū", indonesianTranslation: "kalah", imageRef: "hand.thumbsdown.fill", audioRef: "shu"),
                            Flashcard(hanzi: "加油", pinyin: "jiāyóu", indonesianTranslation: "semangat / ayo!", imageRef: "flame.fill", audioRef: "jiayou")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "今天有篮球比赛。"),
                            DialogLine(speaker: "B", text: "哪个队会赢？"),
                            DialogLine(speaker: "A", text: "我们队不会输！"),
                            DialogLine(speaker: "B", text: "加油！")
                        ]
                    )
                ]
            ),
            Course(
                title: "Bab 14: Profesi",
                description: "Belajar kosakata profesi umum, profesi lain, dan tempat kerja.",
                icon: "工",
                subChapters: [
                    SubChapter(
                        title: "14.1 Profesi Umum",
                        flashcards: [
                            Flashcard(hanzi: "工作", pinyin: "gōngzuò", indonesianTranslation: "pekerjaan / bekerja", imageRef: "briefcase.fill", audioRef: "gongzuo"),
                            Flashcard(hanzi: "医生", pinyin: "yīshēng", indonesianTranslation: "dokter", imageRef: "stethoscope", audioRef: "yisheng"),
                            Flashcard(hanzi: "护士", pinyin: "hùshi", indonesianTranslation: "perawat", imageRef: "cross.case.fill", audioRef: "hushi"),
                            Flashcard(hanzi: "工人", pinyin: "gōngrén", indonesianTranslation: "buruh / pekerja", imageRef: "wrench.and.screwdriver.fill", audioRef: "gongren"),
                            Flashcard(hanzi: "司机", pinyin: "sījī", indonesianTranslation: "sopir", imageRef: "car.fill", audioRef: "siji")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "你爸爸做什么工作？"),
                            DialogLine(speaker: "B", text: "他是医生。"),
                            DialogLine(speaker: "A", text: "你妈妈呢？"),
                            DialogLine(speaker: "B", text: "她是护士。")
                        ]
                    ),
                    SubChapter(
                        title: "14.2 Profesi Lain",
                        flashcards: [
                            Flashcard(hanzi: "警察", pinyin: "jǐngchá", indonesianTranslation: "polisi", imageRef: "star.shield.fill", audioRef: "jingcha"),
                            Flashcard(hanzi: "厨师", pinyin: "chúshī", indonesianTranslation: "koki", imageRef: "frying.pan.fill", audioRef: "chushi"),
                            Flashcard(hanzi: "农民", pinyin: "nóngmín", indonesianTranslation: "petani", imageRef: "leaf.fill", audioRef: "nongmin"),
                            Flashcard(hanzi: "商人", pinyin: "shāngrén", indonesianTranslation: "pedagang", imageRef: "bag.fill", audioRef: "shangren"),
                            Flashcard(hanzi: "律师", pinyin: "lǜshī", indonesianTranslation: "pengacara", imageRef: "building.columns.fill", audioRef: "lushi")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "那个人是警察吗？"),
                            DialogLine(speaker: "B", text: "不是，他是厨师。"),
                            DialogLine(speaker: "A", text: "你想做什么工作？"),
                            DialogLine(speaker: "B", text: "我想当律师。")
                        ]
                    ),
                    SubChapter(
                        title: "14.3 Tempat Kerja",
                        flashcards: [
                            Flashcard(hanzi: "公司", pinyin: "gōngsī", indonesianTranslation: "perusahaan", imageRef: "building.2.fill", audioRef: "gongsi"),
                            Flashcard(hanzi: "上班", pinyin: "shàngbān", indonesianTranslation: "masuk/berangkat kerja", imageRef: "briefcase.fill", audioRef: "shangban"),
                            Flashcard(hanzi: "下班", pinyin: "xiàbān", indonesianTranslation: "pulang kerja", imageRef: "house.fill", audioRef: "xiaban"),
                            Flashcard(hanzi: "忙", pinyin: "máng", indonesianTranslation: "sibuk", imageRef: "clock.badge.exclamationmark.fill", audioRef: "mang"),
                            Flashcard(hanzi: "累", pinyin: "lèi", indonesianTranslation: "lelah / capek", imageRef: "zzz", audioRef: "lei")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "你在哪里上班？"),
                            DialogLine(speaker: "B", text: "我在一家公司上班。"),
                            DialogLine(speaker: "A", text: "工作忙吗？"),
                            DialogLine(speaker: "B", text: "很忙，也很累。")
                        ]
                    )
                ]
            ),
            Course(
                title: "Bab 15: Penyakit",
                description: "Belajar gejala umum penyakit, bagian yang sakit, dan berobat.",
                icon: "病",
                subChapters: [
                    SubChapter(
                        title: "15.1 Gejala Umum",
                        flashcards: [
                            Flashcard(hanzi: "生病", pinyin: "shēngbìng", indonesianTranslation: "sakit / jatuh sakit", imageRef: "bed.double.fill", audioRef: "shengbing"),
                            Flashcard(hanzi: "怎么了", pinyin: "zěnme le", indonesianTranslation: "kenapa / ada apa", imageRef: "questionmark.circle.fill", audioRef: "zenme_le"),
                            Flashcard(hanzi: "感冒", pinyin: "gǎnmào", indonesianTranslation: "flu / masuk angin", imageRef: "thermometer.snowflake", audioRef: "ganmao"),
                            Flashcard(hanzi: "发烧", pinyin: "fāshāo", indonesianTranslation: "demam", imageRef: "thermometer.sun.fill", audioRef: "fashao"),
                            Flashcard(hanzi: "咳嗽", pinyin: "késou", indonesianTranslation: "batuk", imageRef: "waveform.path.ecg", audioRef: "kesou"),
                            Flashcard(hanzi: "头疼", pinyin: "tóuténg", indonesianTranslation: "sakit kepala", imageRef: "brain.head.profile", audioRef: "touteng")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "你怎么了？"),
                            DialogLine(speaker: "B", text: "我生病了，有点儿感冒。"),
                            DialogLine(speaker: "A", text: "你发烧吗？"),
                            DialogLine(speaker: "B", text: "发烧，还头疼、咳嗽。")
                        ]
                    ),
                    SubChapter(
                        title: "15.2 Bagian yang Sakit",
                        flashcards: [
                            Flashcard(hanzi: "舒服", pinyin: "shūfu", indonesianTranslation: "enak badan / nyaman", imageRef: "hand.thumbsup.fill", audioRef: "shufu"),
                            Flashcard(hanzi: "难受", pinyin: "nánshòu", indonesianTranslation: "tidak enak badan", imageRef: "face.dashed", audioRef: "nanshou"),
                            Flashcard(hanzi: "肚子", pinyin: "dùzi", indonesianTranslation: "perut", imageRef: "figure.dress.line.vertical.figure", audioRef: "duzi"),
                            Flashcard(hanzi: "疼", pinyin: "téng", indonesianTranslation: "sakit / nyeri", imageRef: "bolt.heart.fill", audioRef: "teng"),
                            Flashcard(hanzi: "牙", pinyin: "yá", indonesianTranslation: "gigi", imageRef: "mouth.fill", audioRef: "ya"),
                            Flashcard(hanzi: "嗓子", pinyin: "sǎngzi", indonesianTranslation: "tenggorokan", imageRef: "lungs.fill", audioRef: "sangzi")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "你哪里不舒服？"),
                            DialogLine(speaker: "B", text: "我肚子疼。"),
                            DialogLine(speaker: "A", text: "牙疼不疼？"),
                            DialogLine(speaker: "B", text: "不疼，但是嗓子很难受。")
                        ]
                    ),
                    SubChapter(
                        title: "15.3 Berobat",
                        flashcards: [
                            Flashcard(hanzi: "看病", pinyin: "kànbìng", indonesianTranslation: "berobat / periksa", imageRef: "cross.case.fill", audioRef: "kanbing"),
                            Flashcard(hanzi: "药", pinyin: "yào", indonesianTranslation: "obat", imageRef: "pills.fill", audioRef: "yao"),
                            Flashcard(hanzi: "吃药", pinyin: "chī yào", indonesianTranslation: "minum obat", imageRef: "pills.fill", audioRef: "chi_yao"),
                            Flashcard(hanzi: "休息", pinyin: "xiūxi", indonesianTranslation: "istirahat", imageRef: "bed.double.fill", audioRef: "xiuxi"),
                            Flashcard(hanzi: "没事", pinyin: "méishì", indonesianTranslation: "tidak apa-apa", imageRef: "hand.thumbsup.fill", audioRef: "meishi")
                        ],
                        dialogLines: [
                            DialogLine(speaker: "A", text: "你要去医院看病吗？"),
                            DialogLine(speaker: "B", text: "要，医生让我吃药。"),
                            DialogLine(speaker: "A", text: "你要多休息。"),
                            DialogLine(speaker: "B", text: "谢谢，我没事。")
                        ]
                    )
                ]
            )
        ]
    }
}
