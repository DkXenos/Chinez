import SwiftUI
import WebKit

struct HanziWebView: UIViewRepresentable {

    @Binding var character: String
    var useQuizMode: Bool = false
    var onAllStrokesCompleted: (() -> Void)?
    var onCoordinatorReady: ((Coordinator) -> Void)?

    var onCorrectStroke: ((Int) -> Void)?
    var onMistake: (() -> Void)?
    var onQuizComplete: (() -> Void)?

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
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true

        let contentController = config.userContentController
        contentController.add(context.coordinator, name: "allStrokesCompleted")
        contentController.add(context.coordinator, name: "strokeCorrect")
        contentController.add(context.coordinator, name: "strokeMistake")
        contentController.add(context.coordinator, name: "quizComplete")

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false

        webView.isUserInteractionEnabled = useQuizMode

        #if DEBUG
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        }
        #endif

        context.coordinator.webView = webView
        loadLocalHTML(into: webView)

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


        func userContentController(
            _ userContentController: WKUserContentController,
            didReceive message: WKScriptMessage
        ) {
            switch message.name {

            case "allStrokesCompleted":
                DispatchQueue.main.async { [weak self] in
                    self?.onAllStrokesCompleted?()
                }

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

        func animateStroke(at index: Int) {
            let js = "animateStroke(\(index));"
            webView?.evaluateJavaScript(js) { _, error in
                if let error = error {
                    print("[HanziWebView] animateStroke error: \(error.localizedDescription)")
                }
            }
        }

        func animateFullCharacter() {
            webView?.evaluateJavaScript("animateFullCharacter();", completionHandler: nil)
        }

        func resetCharacter() {
            webView?.evaluateJavaScript("resetCharacter();", completionHandler: nil)
        }


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
