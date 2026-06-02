//
//  DesignSystemTests.swift
//  ChinezyUnitTests
//
//  Tests for DesignSystem constants — colors, dimensions, and typography.
//

import XCTest
import SwiftUI
@testable import Chinezy

final class DesignSystemTests: XCTestCase {

    // MARK: - Colors

    func testBrandColorsExist() {
        // Verify colors are accessible (non-crashing)
        let _ = DesignSystem.Colors.primary
        let _ = DesignSystem.Colors.secondary
    }

    func testSurfaceColorsExist() {
        let _ = DesignSystem.Colors.background
        let _ = DesignSystem.Colors.secondaryBackground
        let _ = DesignSystem.Colors.surfaceWhite
        let _ = DesignSystem.Colors.cardBackground
    }

    func testTextColorsExist() {
        let _ = DesignSystem.Colors.textPrimary
        let _ = DesignSystem.Colors.textSecondary
        let _ = DesignSystem.Colors.textDark
    }

    func testSemanticColorsExist() {
        let _ = DesignSystem.Colors.error
        let _ = DesignSystem.Colors.gold
        let _ = DesignSystem.Colors.success
        let _ = DesignSystem.Colors.goldLight
    }

    func testBorderColorsExist() {
        let _ = DesignSystem.Colors.cardBorder
        let _ = DesignSystem.Colors.primaryDark
    }

    func testErrorIsPrimary() {
        // error is an alias for primary
        XCTAssertEqual(
            DesignSystem.Colors.error.description,
            DesignSystem.Colors.primary.description
        )
    }

    func testGoldIsSecondary() {
        // gold is an alias for secondary
        XCTAssertEqual(
            DesignSystem.Colors.gold.description,
            DesignSystem.Colors.secondary.description
        )
    }

    // MARK: - Dimensions

    func testDimensionsArePositive() {
        XCTAssertGreaterThan(DesignSystem.Dimensions.cornerRadius, 0)
        XCTAssertGreaterThan(DesignSystem.Dimensions.cornerRadiusSmall, 0)
        XCTAssertGreaterThan(DesignSystem.Dimensions.cornerRadiusMedium, 0)
        XCTAssertGreaterThan(DesignSystem.Dimensions.paddingStandard, 0)
        XCTAssertGreaterThan(DesignSystem.Dimensions.paddingLarge, 0)
        XCTAssertGreaterThan(DesignSystem.Dimensions.paddingSmall, 0)
    }

    func testDimensionOrdering() {
        // Small < Medium < Standard/Large
        XCTAssertLessThanOrEqual(
            DesignSystem.Dimensions.cornerRadiusSmall,
            DesignSystem.Dimensions.cornerRadiusMedium
        )
        XCTAssertLessThanOrEqual(
            DesignSystem.Dimensions.cornerRadiusMedium,
            DesignSystem.Dimensions.cornerRadius
        )
        XCTAssertLessThanOrEqual(
            DesignSystem.Dimensions.paddingSmall,
            DesignSystem.Dimensions.paddingStandard
        )
        XCTAssertLessThanOrEqual(
            DesignSystem.Dimensions.paddingStandard,
            DesignSystem.Dimensions.paddingLarge
        )
    }

    func testDimensionValues() {
        XCTAssertEqual(DesignSystem.Dimensions.cornerRadius, 16)
        XCTAssertEqual(DesignSystem.Dimensions.cornerRadiusSmall, 12)
        XCTAssertEqual(DesignSystem.Dimensions.cornerRadiusMedium, 14)
        XCTAssertEqual(DesignSystem.Dimensions.paddingStandard, 16)
        XCTAssertEqual(DesignSystem.Dimensions.paddingLarge, 24)
        XCTAssertEqual(DesignSystem.Dimensions.paddingSmall, 12)
    }

    // MARK: - Typography

    func testTypographyFontsExist() {
        // Verify all fonts are accessible (non-crashing)
        let _ = DesignSystem.Typography.largeTitle
        let _ = DesignSystem.Typography.title
        let _ = DesignSystem.Typography.title2
        let _ = DesignSystem.Typography.title3
        let _ = DesignSystem.Typography.headline
        let _ = DesignSystem.Typography.subheadline
        let _ = DesignSystem.Typography.subheadlineBold
        let _ = DesignSystem.Typography.body
        let _ = DesignSystem.Typography.caption
    }
}
