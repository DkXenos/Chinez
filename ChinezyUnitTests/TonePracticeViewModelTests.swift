//
//  TonePracticeViewModelTests.swift
//  ChinezyUnitTests
//
//  Tests for TonePracticeViewModel.
//

import XCTest
@testable import Chinezy

@MainActor
final class TonePracticeViewModelTests: XCTestCase {

    // MARK: - Initial State

    func testInitialState() {
        let vm = TonePracticeViewModel()

        XCTAssertEqual(vm.selectedIndex, 0)
        XCTAssertFalse(vm.targets.isEmpty)
        XCTAssertEqual(vm.targets, HanziTarget.defaults)
    }

    // MARK: - currentTarget

    func testCurrentTarget() {
        let vm = TonePracticeViewModel()
        let expected = vm.targets[0]

        XCTAssertEqual(vm.currentTarget.character, expected.character)
        XCTAssertEqual(vm.currentTarget.pinyin, expected.pinyin)
        XCTAssertEqual(vm.currentTarget.targetTone, expected.targetTone)
    }

    func testCurrentTargetUpdatesWithIndex() {
        let vm = TonePracticeViewModel()

        let target0 = vm.targets[0]
        XCTAssertEqual(vm.currentTarget.character, target0.character)

        vm.selectedIndex = 1
        let target1 = vm.targets[1]
        XCTAssertEqual(vm.currentTarget.character, target1.character)
    }

    // MARK: - configure

    func testConfigure() {
        let vm = TonePracticeViewModel()
        let customTargets = [
            HanziTarget(character: "大", pinyin: "dà", targetTone: "Tone_4"),
            HanziTarget(character: "小", pinyin: "xiǎo", targetTone: "Tone_3")
        ]

        vm.configure(targets: customTargets, startIndex: 1)

        XCTAssertEqual(vm.targets.count, 2)
        XCTAssertEqual(vm.selectedIndex, 1)
        XCTAssertEqual(vm.currentTarget.character, "小")
    }

    func testConfigureClampIndex() {
        let vm = TonePracticeViewModel()
        let customTargets = [
            HanziTarget(character: "大", pinyin: "dà", targetTone: "Tone_4")
        ]

        vm.configure(targets: customTargets, startIndex: 99) // Out of bounds
        XCTAssertEqual(vm.selectedIndex, 0) // Should be clamped to max valid index
    }

    // MARK: - evaluateResult — Correct

    func testEvaluateResultCorrect() {
        let vm = TonePracticeViewModel()
        let toneService = ToneEvaluatorService()

        // Create a VM with the service we can manipulate
        let customVM = TonePracticeViewModel(toneService: toneService)
        let targets = [HanziTarget(character: "妈", pinyin: "mā", targetTone: "Tone_1")]
        customVM.configure(targets: targets, startIndex: 0)

        // Simulate predicted tone matching target
        toneService.predictedTone = "Tone_1"

        let verdict = customVM.evaluateResult()
        XCTAssertTrue(verdict.text.contains("Correct"))
        XCTAssertEqual(verdict.icon, "checkmark.circle.fill")
    }

    // MARK: - evaluateResult — Wrong

    func testEvaluateResultWrong() {
        let toneService = ToneEvaluatorService()
        let vm = TonePracticeViewModel(toneService: toneService)
        let targets = [HanziTarget(character: "妈", pinyin: "mā", targetTone: "Tone_1")]
        vm.configure(targets: targets, startIndex: 0)

        toneService.predictedTone = "Tone_4"

        let verdict = vm.evaluateResult()
        XCTAssertTrue(verdict.text.contains("Detected"))
        XCTAssertEqual(verdict.icon, "xmark.circle.fill")
    }

    // MARK: - evaluateResult — Unclear

    func testEvaluateResultUnclear() {
        let toneService = ToneEvaluatorService()
        let vm = TonePracticeViewModel(toneService: toneService)

        toneService.predictedTone = "Unclear"

        let verdict = vm.evaluateResult()
        XCTAssertEqual(verdict.text, "Unclear")
        XCTAssertEqual(verdict.icon, "exclamationmark.triangle.fill")
    }

    // MARK: - serviceState

    func testServiceStateForwarded() {
        let toneService = ToneEvaluatorService()
        let vm = TonePracticeViewModel(toneService: toneService)

        // Initial state should be idle
        XCTAssertEqual(vm.serviceState, .idle)
    }
}
