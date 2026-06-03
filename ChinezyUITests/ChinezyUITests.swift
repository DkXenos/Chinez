//
//  ChinezyUITests.swift
//  ChinezyUITests
//
//  Created by Jason TIo on 02/06/26.
//  Comprehensive UI tests for the Chinezy app — auth flow and app launch.
//

import XCTest

final class ChinezyUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        // Inject argument to force clean state and bypass splash screens
        app.launchArguments.append("-UITesting")
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - App Launch

    /// Verifies the app launches without crashing.
    @MainActor
    func testAppLaunchesSuccessfully() throws {
        // If we reach this point, the app launched without a crash.
        XCTAssertTrue(app.exists, "App should exist after launch.")
    }

    // MARK: - Auth Screen Elements

    /// Verifies the login screen displays the welcome header.
    @MainActor
    func testAuthScreenShowsWelcomeHeader() throws {
        let welcomeText = app.staticTexts["Auth.WelcomeHeader"]
        XCTAssertTrue(
            welcomeText.waitForExistence(timeout: 5),
            "The header should be visible on the auth screen."
        )
    }

    /// Verifies the login subtitle text is shown.
    @MainActor
    func testAuthScreenShowsSubtitle() throws {
        let subtitle = app.staticTexts["Auth.Subtitle"]
        XCTAssertTrue(
            subtitle.waitForExistence(timeout: 5),
            "The subtitle should be visible on the auth screen."
        )
    }

    /// Verifies the Email text field is present on the auth screen.
    @MainActor
    func testAuthScreenHasEmailField() throws {
        let emailField = app.textFields["Auth.EmailField"]
        XCTAssertTrue(
            emailField.waitForExistence(timeout: 5),
            "The Email text field should be visible on the auth screen."
        )
    }

    /// Verifies the Password secure field is present on the auth screen.
    @MainActor
    func testAuthScreenHasPasswordField() throws {
        let passwordField = app.secureTextFields["Auth.PasswordField"]
        XCTAssertTrue(
            passwordField.waitForExistence(timeout: 5),
            "The Password field should be visible on the auth screen."
        )
    }

    /// Verifies the action button is present on the auth screen.
    @MainActor
    func testAuthScreenHasLoginButton() throws {
        let loginButton = app.buttons["Auth.ActionButton"]
        XCTAssertTrue(
            loginButton.waitForExistence(timeout: 5),
            "The action button should be visible on the auth screen."
        )
    }

    /// Verifies the toggle mode link is present.
    @MainActor
    func testAuthScreenHasSignUpToggle() throws {
        let toggleButton = app.buttons["Auth.ToggleButton"]
        XCTAssertTrue(
            toggleButton.waitForExistence(timeout: 5),
            "The toggle button should be visible."
        )
    }

    // MARK: - Auth Mode Toggle

    /// Verifies tapping the toggle switches mode correctly.
    @MainActor
    func testToggleToSignUpMode() throws {
        let toggleButton = app.buttons["Auth.ToggleButton"]
        XCTAssertTrue(toggleButton.waitForExistence(timeout: 5))

        toggleButton.tap()

        // After toggling, we should see header change text but same identifier
        let headerText = app.staticTexts["Auth.WelcomeHeader"]
        XCTAssertTrue(
            headerText.waitForExistence(timeout: 3),
            "After toggling, header should be visible."
        )
        // Ensure it switched to sign up mode
        XCTAssertEqual(headerText.label, "Create Account")
        
        // The action button should say "Sign Up"
        let actionButton = app.buttons["Auth.ActionButton"]
        XCTAssertTrue(
            actionButton.waitForExistence(timeout: 3),
            "The action button should be visible."
        )
        XCTAssertEqual(actionButton.label, "Sign Up")
    }

    /// Verifies toggling back from sign-up to login mode.
    @MainActor
    func testToggleBackToLoginMode() throws {
        let toggleButton = app.buttons["Auth.ToggleButton"]
        XCTAssertTrue(toggleButton.waitForExistence(timeout: 5))
        
        // First go to sign-up mode
        toggleButton.tap()

        // Then toggle back to login mode
        toggleButton.tap()

        // Should be back to login
        let headerText = app.staticTexts["Auth.WelcomeHeader"]
        XCTAssertTrue(
            headerText.waitForExistence(timeout: 3),
            "After toggling back, header should be visible."
        )
        XCTAssertEqual(headerText.label, "Welcome Back")
    }

    // MARK: - Auth Field Interaction

    /// Verifies the user can type into the Email field.
    @MainActor
    func testCanTypeInEmailField() throws {
        let emailField = app.textFields["Auth.EmailField"]
        XCTAssertTrue(emailField.waitForExistence(timeout: 5))

        emailField.tap()
        
        // Wait for keyboard focus to avoid SwiftUI animation lag causing 'Neither element nor any descendant has keyboard focus'
        let hasFocus = NSPredicate(format: "hasKeyboardFocus == true")
        let focusExpectation = expectation(for: hasFocus, evaluatedWith: emailField, handler: nil)
        wait(for: [focusExpectation], timeout: 3.0)
        
        emailField.typeText("test@example.com")

        // Verify the text was entered (value should contain what we typed)
        let fieldValue = emailField.value as? String ?? ""
        XCTAssertTrue(
            fieldValue.contains("test@example.com"),
            "Email field should contain the typed text."
        )
    }

    /// Verifies the user can type into the Password field.
    @MainActor
    func testCanTypeInPasswordField() throws {
        let passwordField = app.secureTextFields["Auth.PasswordField"]
        XCTAssertTrue(passwordField.waitForExistence(timeout: 5))

        passwordField.tap()
        
        // Wait for keyboard focus
        let hasFocus = NSPredicate(format: "hasKeyboardFocus == true")
        let focusExpectation = expectation(for: hasFocus, evaluatedWith: passwordField, handler: nil)
        wait(for: [focusExpectation], timeout: 3.0)
        
        passwordField.typeText("password123")

        // SecureField won't expose the actual value, but we verify no crash
        XCTAssertTrue(passwordField.exists, "Password field should still exist after typing.")
    }

}
