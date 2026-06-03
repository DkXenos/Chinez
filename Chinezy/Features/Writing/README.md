# Writing Feature Architecture

This document explains the architecture, folder structure, and data flow of the **Writing Feature** in Chinezy. 

The Writing feature allows users to practice their Hanzi stroke order interactively. It is built entirely on a **100% Offline Architecture**, meaning users do not need an internet connection to load characters, outlines, or stroke guides.

---

## 📂 Folder Structure

The feature is organized into Views and ViewModels inside the `Features/Writing` directory, but it also heavily relies on shared components located in the `Core` directory.

### UI & Presentation (`Features/Writing/`)
* **`WritingLevelListView.swift`**
  * Displays the list of available writing exercises/levels (e.g., "Angka Dasar", "Kata Sapaan").
  * Uses `WritingLevelListViewModel` to fetch the list of levels.
* **`QuizView.swift`** *(Contains `WritingQuizView`)*
  * The main interactive writing canvas screen.
  * Contains the target character, the mistake counter, and the interactive `HanziWebView`.
* **`ViewModel/WritingLevelListViewModel.swift`**
  * Manages the data state for the level list, fetching data via `WritingDataService`.
* **`ViewModel/WritingQuizViewModel.swift`**
  * Tracks user progress during a quiz (current character, mistakes made, strokes completed).
  * Handles the logic for advancing to the next character or finishing the quiz, triggering `onFinish()` to navigate back.

### Core Dependencies (`Core/`)
* **`Core/Components/HanziWebView.swift`**
  * The Swift wrapper (`UIViewRepresentable`) around a `WKWebView`. It bridges SwiftUI and the JavaScript `HanziWriter` library.
* **`Core/Resources/HanziQuiz.html`**
  * The local HTML file containing the grid UI and the JavaScript bridge logic.
* **`Core/Resources/hanzi-writer.min.js`**
  * The core HanziWriter JavaScript library itself. It is bundled locally and injected into the `HanziQuiz.html` via `<script src="hanzi-writer.min.js">`, meaning the JS engine does not fetch the library from `jsdelivr` or any external CDN.
* **`Core/Resources/WritingExercise.json`**
  * A JSON file containing the syllabus/curriculum (the levels and which characters belong to which level).
* **`Core/Resources/hanzi-writer-data/`**
  * A local directory containing 80+ `.json` files. Each file contains the raw SVG stroke path data for a specific Hanzi character (e.g., `吃.json`).

---

## 🚫 No CDN / 100% Local Data Flow

Every asset and logic step in this feature executes purely on the device.
1. The **JS Library** (`hanzi-writer.min.js`) is bundled.
2. The **HTML/CSS UI** (`HanziQuiz.html`) is bundled.
3. The **Character Stroke SVGs** (`hanzi-writer-data/`) are bundled.

The Swift-to-JS bridge passes data through a highly optimized Base64 pipeline to prevent JS from attempting to fetch missing characters from its default `https://cdn.jsdelivr.net` endpoints.

### 1. Curriculum Loading
When the user opens the app and navigates to the Writing tab, `WritingDataService` reads `WritingExercise.json` from the local app bundle. This populates `WritingLevelListView` with the list of levels.

### 2. Entering a Quiz
When a user taps a level, the `WritingQuizView` is initialized with a `WritingLevel` object containing a list of characters (e.g., `["吃", "喝", ...]`). 
`WritingQuizViewModel` sets the first character as the `currentCharacter`.

### 3. The Swift-to-JS Bridge (`HanziWebView`)
Whenever `currentCharacter` changes, the following offline data injection occurs:
1. **File Lookup:** `HanziWebView` searches the Xcode bundle for the specific character's stroke data (e.g., `吃.json`). It uses a fallback strategy to search both the `hanzi-writer-data` subdirectory and the root bundle.
2. **Base64 Encoding:** To guarantee the JSON payload doesn't break JavaScript syntax with rogue quotes or backslashes, Swift converts the file's binary `Data` directly into a **Base64 String**.
3. **Evaluation:** Swift calls `webView.evaluateJavaScript()` passing the Base64 string to a global JS function (`loadBase64CharacterForQuiz`).

### 4. JavaScript Rendering (`HanziQuiz.html`)
1. **Decoding:** The JavaScript function safely decodes the Base64 string back into a standard JSON object using `decodeURIComponent(escape(window.atob(base64String)))`.
2. **Initialization:** It initializes `HanziWriter`, supplying the decoded JSON object directly into the `charDataLoader` property.
3. **Interactivity:** The `writer.quiz()` method is called, activating the interactive touch layer. Because the data is local, the character outline renders **instantaneously**.

### 5. Callbacks & Scoring
As the user draws on the screen using their finger:
* **JS to Swift:** HanziWriter analyzes the strokes. If correct, JS sends a message (`strokeCorrect`) to Swift via `window.webkit.messageHandlers`. If wrong, it sends `strokeMistake`.
* **Swift Updates UI:** The `Coordinator` inside `HanziWebView` catches these messages and routes them to `WritingQuizViewModel`. The ViewModel updates the mistake counter or triggers haptic feedback (`UIImpactFeedbackGenerator`).
* **Completion:** When the final stroke is drawn, `quizComplete` is fired. The ViewModel shows the "Benar!" success banner, waits 1.5 seconds, and loads the next character (restarting the Data Flow loop at step 3). If it was the last character, the View is dismissed.

---

## 🔗 Relationship to other Modules (e.g., Features/Exercise)

It is important to distinguish the **Writing Feature** (`Features/Writing/`) from the **Exercise Feature** (`Features/Exercise/`):

1. **`Features/Exercise/` & `ExerciseContainerView.swift`**
   * This is a completely separate feature module for *Learning* characters. 
   * It uses a dual-layer approach: the user draws using native Apple `PencilKit` (`StrokeCanvasView`), and `HanziWebView` sits in the background purely to *animate* the stroke when the user gets it right.
2. **`HSK1_StrokeData.json`**
   * This file is **NOT** used by the Writing Feature. 
   * It contains geometric "medians" (center lines) used exclusively by `StrokeValidator.swift` to grade the native PencilKit strokes in the `Features/Exercise` module.
3. **Shared Bridge (`HanziWebView.swift`)**
   * Both features share the exact same `HanziWebView` bridge!
   * In `Features/Exercise`, it runs in **Animation Mode** (`useQuizMode = false`), where interaction is disabled and Swift tells JS to animate strokes one-by-one.
   * In `Features/Writing`, it runs in **Interactive Quiz Mode** (`useQuizMode = true`), where JS handles all the touch input, validation, and rendering locally using the SVG data from `hanzi-writer-data/`.
