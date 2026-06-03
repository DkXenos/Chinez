import SwiftUI
import WebKit

// MARK: - HanziWebView
/// A `UIViewRepresentable` that wraps a `WKWebView` to render Hanzi Writer.
///
/// Supports **two modes** via `useQuizMode`:
///
/// ### Mode 1: Animation-Only (default, `useQuizMode = false`)
/// User interaction is disabled. The native PencilKit/touch layer handles
/// drawing. Swift calls `animateStroke(index)` when the `StrokeValidator`
/// confirms a correct stroke, and Hanzi Writer inks it in.
/// Used by `ExerciseContainerView`.
///
/// ### Mode 2: Interactive Quiz (`useQuizMode = true`)
/// HanziWriter's built-in `writer.quiz()` mode handles all touch input.
/// Sends `strokeCorrect`, `strokeMistake`, `quizComplete` messages back
/// to Swift via `webkit.messageHandlers`.
/// Used by `WritingQuizView`.
struct HanziWebView: UIViewRepresentable {

    // MARK: – Public Interface

    /// The character to display. Changing this value loads the new
    /// character outline and resets all animated strokes.
    @Binding var character: String

    /// When `true`, uses HanziWriter's `writer.quiz()` mode for interactive
    /// stroke input. When `false`, operates in animation-only mode.
    /// Default is `false` for backward compatibility with ExerciseContainerView.
    var useQuizMode: Bool = false

    /// Closure fired after the final stroke animation completes (animation mode).
    var onAllStrokesCompleted: (() -> Void)?

    /// Delivers the Coordinator reference so the parent can call
    /// `animateStroke(at:)` from the native drawing layer (animation mode).
    var onCoordinatorReady: ((Coordinator) -> Void)?

    // MARK: Quiz Mode Callbacks

    /// Fires when a correct stroke is drawn in quiz mode.
    /// Parameter: stroke index (0-based).
    var onCorrectStroke: ((Int) -> Void)?

    /// Fires when an incorrect stroke is drawn in quiz mode.
    var onMistake: (() -> Void)?

    /// Fires when all strokes are completed in quiz mode.
    var onQuizComplete: (() -> Void)?

    // MARK: – UIViewRepresentable

    func makeCoordinator() -> Coordinator {
        Coordinator(
            useQuizMode: useQuizMode,
            onAllStrokesCompleted: onAllStrokesCompleted,
            onCorrectStroke: onCorrectStroke,
            onMistake: onMistake,
            onQuizComplete: onQuizComplete
        )
    }

    func makeUIView(context: Context) -> WKWebView {
        // ── Configuration ───────────────────────────────────────────
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true

        // Register JS → Swift message handlers
        let contentController = config.userContentController
        contentController.add(context.coordinator, name: "allStrokesCompleted")
        contentController.add(context.coordinator, name: "strokeCorrect")
        contentController.add(context.coordinator, name: "strokeMistake")
        contentController.add(context.coordinator, name: "quizComplete")

        // ── Create the web view ─────────────────────────────────────
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false

        // Quiz mode: enable touch (HanziWriter handles interaction).
        // Animation mode: disable touch (native PencilKit layer handles it).
        webView.isUserInteractionEnabled = useQuizMode

        #if DEBUG
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        }
        #endif

        context.coordinator.webView = webView
        loadLocalHTML(into: webView)

        // Deliver the coordinator reference to the parent
        DispatchQueue.main.async { [coordinator = context.coordinator] in
            self.onCoordinatorReady?(coordinator)
        }

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let coordinator = context.coordinator
        if coordinator.currentCharacter != character {
            coordinator.currentCharacter = character
            coordinator.loadCharacter(character)
        }
    }

    // MARK: – Helpers

    private func loadLocalHTML(into webView: WKWebView) {
        guard let htmlURL = Bundle.main.url(
            forResource: "HanziQuiz",
            withExtension: "html"
        ) else {
            assertionFailure(
                "[HanziWebView] HanziQuiz.html not found in the main bundle. "
                + "Ensure it is added to the target's 'Copy Bundle Resources' build phase."
            )
            return
        }
        let resourceDir = htmlURL.deletingLastPathComponent()
        webView.loadFileURL(htmlURL, allowingReadAccessTo: resourceDir)
    }

    // MARK: – Coordinator

    class Coordinator: NSObject, WKScriptMessageHandler {

        weak var webView: WKWebView?
        var currentCharacter: String = ""
        let useQuizMode: Bool

        private let onAllStrokesCompleted: (() -> Void)?
        private let onCorrectStroke: ((Int) -> Void)?
        private let onMistake: (() -> Void)?
        private let onQuizComplete: (() -> Void)?

        init(
            useQuizMode: Bool,
            onAllStrokesCompleted: (() -> Void)?,
            onCorrectStroke: ((Int) -> Void)?,
            onMistake: (() -> Void)?,
            onQuizComplete: (() -> Void)?
        ) {
            self.useQuizMode = useQuizMode
            self.onAllStrokesCompleted = onAllStrokesCompleted
            self.onCorrectStroke = onCorrectStroke
            self.onMistake = onMistake
            self.onQuizComplete = onQuizComplete
            super.init()
        }

        // MARK: WKScriptMessageHandler

        func userContentController(
            _ userContentController: WKUserContentController,
            didReceive message: WKScriptMessage
        ) {
            switch message.name {

            // ── Animation mode callback ─────────────────────────────
            case "allStrokesCompleted":
                DispatchQueue.main.async { [weak self] in
                    self?.onAllStrokesCompleted?()
                }

            // ── Quiz mode callbacks ─────────────────────────────────
            case "strokeCorrect":
                if let body = message.body as? [String: Any],
                   let strokeNum = body["strokeNum"] as? Int {
                    DispatchQueue.main.async { [weak self] in
                        self?.onCorrectStroke?(strokeNum)
                    }
                }

            case "strokeMistake":
                DispatchQueue.main.async { [weak self] in
                    self?.onMistake?()
                }

            case "quizComplete":
                DispatchQueue.main.async { [weak self] in
                    self?.onQuizComplete?()
                }

            default:
                break
            }
        }

        // MARK: – JS Bridge Methods

        /// Loads a character into Hanzi Writer using fully local stroke data.
        func loadCharacter(_ character: String) {
            guard !character.isEmpty else { return }

            guard let base64String = fetchLocalStrokeData(for: character) else { return }

            let escapedChar = character
                .replacingOccurrences(of: "\\", with: "\\\\")
                .replacingOccurrences(of: "'", with: "\\'")

            if useQuizMode {
                let js = "loadBase64CharacterForQuiz('\(escapedChar)', '\(base64String)');"
                evaluateWithRetry(js)
            } else {
                let js = "loadBase64Character('\(escapedChar)', '\(base64String)');"
                evaluateWithRetry(js)
            }
        }

        /// Animates a single stroke at the given index (animation mode).
        /// Called by the native StrokeCanvasView after validation succeeds.
        func animateStroke(at index: Int) {
            let js = "animateStroke(\(index));"
            webView?.evaluateJavaScript(js) { _, error in
                if let error = error {
                    print("[HanziWebView] animateStroke error: \(error.localizedDescription)")
                }
            }
        }

        /// Plays the full character animation (useful for review/demo).
        func animateFullCharacter() {
            webView?.evaluateJavaScript("animateFullCharacter();", completionHandler: nil)
        }

        /// Hides all strokes to restart.
        func resetCharacter() {
            webView?.evaluateJavaScript("resetCharacter();", completionHandler: nil)
        }

        // MARK: – Data Injection

        private func fetchLocalStrokeData(for character: String) -> String? {
            var url = Bundle.main.url(forResource: character, withExtension: "json", subdirectory: "hanzi-writer-data")
            if url == nil {
                url = Bundle.main.url(forResource: character, withExtension: "json")
            }
            
            guard let validURL = url else {
                print("❌ SWIFT ERROR: Cannot find file for \(character).json in bundle.")
                return nil
            }
            
            do {
                let data = try Data(contentsOf: validURL)
                return data.base64EncodedString()
            } catch {
                print("❌ SWIFT ERROR reading local data for \(character): \(error.localizedDescription)")
                return nil
            }
        }

        // MARK: Helpers

        private func evaluateWithRetry(_ js: String) {
            webView?.evaluateJavaScript(js) { [weak self] _, error in
                if let error = error {
                    print("[HanziWebView] JS error (will retry): \(error.localizedDescription)")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        self?.webView?.evaluateJavaScript(js, completionHandler: nil)
                    }
                }
            }
        }
    }
}
