import SwiftUI
import WebKit

// MARK: - HanziWebView
/// A `UIViewRepresentable` that wraps a `WKWebView` to render Hanzi Writer
/// as a **visual stroke animator** — NOT for touch input. User interaction
/// is disabled on the web view; the native PencilKit/touch layer handles
/// drawing. Swift calls `animateStroke(index)` when the `StrokeValidator`
/// confirms a correct stroke, and Hanzi Writer inks it in with animation.
///
/// ## Usage
/// ```swift
/// HanziWebView(
///     character: $currentCharacter,
///     onAllStrokesCompleted: { print("All strokes animated!") }
/// )
/// .allowsHitTesting(false) // native layer handles touch
/// ```
struct HanziWebView: UIViewRepresentable {

    // MARK: – Public Interface

    /// The character to display. Changing this value loads the new
    /// character outline and resets all animated strokes.
    @Binding var character: String

    /// Closure fired after the final stroke animation completes.
    var onAllStrokesCompleted: (() -> Void)?

    /// Delivers the Coordinator reference so the parent can call
    /// `animateStroke(at:)` from the native drawing layer.
    var onCoordinatorReady: ((Coordinator) -> Void)?

    // MARK: – UIViewRepresentable

    func makeCoordinator() -> Coordinator {
        Coordinator(onAllStrokesCompleted: onAllStrokesCompleted)
    }

    func makeUIView(context: Context) -> WKWebView {
        // ── Configuration ───────────────────────────────────────────
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true

        // Register the JS → Swift message handler
        let contentController = config.userContentController
        contentController.add(context.coordinator, name: "allStrokesCompleted")

        // ── Create the web view ─────────────────────────────────────
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false

        // ⚡ Disable ALL user interaction — the native drawing layer
        //    sits on top and handles touch/pencil input.
        webView.isUserInteractionEnabled = false

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

        private let onAllStrokesCompleted: (() -> Void)?

        init(onAllStrokesCompleted: (() -> Void)?) {
            self.onAllStrokesCompleted = onAllStrokesCompleted
            super.init()
        }

        // MARK: WKScriptMessageHandler

        func userContentController(
            _ userContentController: WKUserContentController,
            didReceive message: WKScriptMessage
        ) {
            if message.name == "allStrokesCompleted" {
                DispatchQueue.main.async { [weak self] in
                    self?.onAllStrokesCompleted?()
                }
            }
        }

        // MARK: – JS Bridge Methods

        /// Loads a character into Hanzi Writer (outline visible, strokes hidden).
        func loadCharacter(_ character: String) {
            guard !character.isEmpty else { return }
            let escaped = character
                .replacingOccurrences(of: "\\", with: "\\\\")
                .replacingOccurrences(of: "'", with: "\\'")
            let js = "loadCharacter('\(escaped)');"
            evaluateWithRetry(js)
        }

        /// Animates a single stroke at the given index.
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
