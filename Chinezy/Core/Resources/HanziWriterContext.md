# ARCHITECTURE CONTEXT: CHINEZ APP - HANZI WRITING FEATURE

## 1. Core Rule: STRICTLY 100% OFFLINE (NO CDN)
Under NO circumstances should the app fetch stroke data from the internet (e.g., `cdn.jsdelivr.net`). The app MUST be completely self-contained to guarantee zero loading time and prevent crashes during offline presentations.

## 2. Data Source Strategy
- **The Local File:** All stroke vector data is stored locally in `HSK1_StrokeData.json`.
- **The Swift Bridge:** The native Swift layer is responsible for parsing this JSON file, locating the specific character (e.g., "妈"), and converting that character's vector data into a raw JSON String.
- **The JavaScript Injection:** Swift MUST inject this JSON String directly into the WKWebView using `evaluateJavaScript`.

## 3. HanziWriter Initialization Protocol
When initializing the `HanziWriter` instance inside the HTML/JS file (`HanziQuiz.html` or injected JS), you MUST override the `charDataLoader` property. 

**Correct Implementation Pattern:**
```javascript
var writer = HanziWriter.create('character-target-div', targetCharacter, {
    width: 300,
    height: 300,
    padding: 20,
    showCharacter: false,
    showOutline: true,
    // THE OFFLINE BRIDGE:
    charDataLoader: function(char, onComplete) {
        // 'injectedLocalData' is a variable populated by Swift via evaluateJavaScript
        // BEFORE the writer is initialized.
        onComplete(injectedLocalData); 
    }
}); ```

## 4. Stroke Progression & Quiz Mode
To ensure the user gets interactive feedback when drawing strokes:
Data must be loaded via the custom charDataLoader first.
Immediately after initialization, you MUST call writer.quiz(); to activate the interactive drawing canvas.
Example:
```
JavaScript
writer.quiz({
    onCorrectStroke: function(strokeData) {
        // Send message back to Swift using webkit.messageHandlers
        window.webkit.messageHandlers.strokeCorrect.postMessage(strokeData);
    },
    onComplete: function(summaryData) {
        // Send completion message back to Swift
        window.webkit.messageHandlers.quizComplete.postMessage(summaryData);
    }
});
```

## 5. Development Directive
If asked to refactor or update the WritingView or the WKWebView coordinator, you MUST verify that:
The Swift code successfully reads HSK1_StrokeData.json.
The custom charDataLoader is present in the JS.
writer.quiz() is actively called so the user can interact.
DO NOT hallucinate external API calls.
