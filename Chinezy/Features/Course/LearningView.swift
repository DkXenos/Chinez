import Combine
import SwiftUI

struct LearningView: View {
    let subChapter: SubChapter
    @StateObject private var viewModel = LearningViewModel()

    public var body: some View {
        ZStack {
            DesignSystem.Colors.background.ignoresSafeArea()

            VStack(spacing: DesignSystem.Dimensions.paddingStandard) {
                if viewModel.isShowingDialog {
                    LearningDialogView(
                        dialogText: subChapter.dialogText,
                        onPlayAudio: viewModel.playDialogAudio
                    )
                } else if let flashcard = viewModel.currentFlashcard {
                    LearningFlashcardContent(
                        flashcard: flashcard,
                        isFlipped: viewModel.isCardFlipped,
                        currentIndex: viewModel.currentFlashcardIndex,
                        totalCount: subChapter.flashcards.count,
                        onTap: {
                            viewModel.flipCard()
                            if viewModel.isCardFlipped {
                                viewModel.playFlashcardAudio()
                            }
                        }
                    )
                }

                Spacer()

                LearningBottomNavigationBar(
                    isShowingDialog: viewModel.isShowingDialog,
                    currentIndex: viewModel.currentFlashcardIndex,
                    totalCount: subChapter.flashcards.count,
                    onPrevious: viewModel.goToPreviousFlashcard,
                    onNextFlashcard: viewModel.goToNextFlashcard,
                    onOpenDialog: {
                        withAnimation { viewModel.openDialog() }
                    },
                    onBackToFlashcard: {
                        withAnimation { viewModel.goToPreviousFlashcard() }
                    }
                )
            }
            .padding(DesignSystem.Dimensions.paddingStandard)
        }
        .navigationTitle(subChapter.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.startLearning(subChapter: subChapter)
        }
        .onDisappear {
            viewModel.stopAudio()
        }
    }
}

#Preview {
    LearningView(subChapter:
        SubChapter(
            title: "1.1 Menyapa",
            flashcards: [
                Flashcard(hanzi: "你好", pinyin: "nǐ hǎo", indonesianTranslation: "halo", imageRef: "hand.wave.fill", audioRef: "")
            ],
            dialogText: "A: 你好！\nB: 你好！"
        )
    )
}
