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

    /// Verifies the login screen displays the "Welcome Back" header.
    @MainActor
    func testAuthScreenShowsWelcomeHeader() throws {
        let welcomeText = app.staticTexts["Welcome Back"]
        XCTAssertTrue(
            welcomeText.waitForExistence(timeout: 5),
            "The 'Welcome Back' header should be visible on the auth screen."
        )
    }

    /// Verifies the login subtitle text is shown.
    @MainActor
    func testAuthScreenShowsSubtitle() throws {
        let subtitle = app.staticTexts["Log in to continue your learning journey"]
        XCTAssertTrue(
            subtitle.waitForExistence(timeout: 5),
            "The login subtitle should be visible on the auth screen."
        )
    }

    /// Verifies the Email text field is present on the auth screen.
    @MainActor
    func testAuthScreenHasEmailField() throws {
        let emailField = app.textFields["Email"]
        XCTAssertTrue(
            emailField.waitForExistence(timeout: 5),
            "The Email text field should be visible on the auth screen."
        )
    }

    /// Verifies the Password secure field is present on the auth screen.
    @MainActor
    func testAuthScreenHasPasswordField() throws {
        let passwordField = app.secureTextFields["Password"]
        XCTAssertTrue(
            passwordField.waitForExistence(timeout: 5),
            "The Password field should be visible on the auth screen."
        )
    }

    /// Verifies the "Log In" button is present on the auth screen.
    @MainActor
    func testAuthScreenHasLoginButton() throws {
        let loginButton = app.buttons["Log In"]
        XCTAssertTrue(
            loginButton.waitForExistence(timeout: 5),
            "The 'Log In' button should be visible on the auth screen."
        )
    }

    /// Verifies the toggle link to switch to sign-up mode is present.
    @MainActor
    func testAuthScreenHasSignUpToggle() throws {
        let toggleButton = app.buttons["Need an account? Sign Up"]
        XCTAssertTrue(
            toggleButton.waitForExistence(timeout: 5),
            "The 'Need an account? Sign Up' toggle button should be visible."
        )
    }

    // MARK: - Auth Mode Toggle

    /// Verifies tapping the toggle switches from login to sign-up mode.
    @MainActor
    func testToggleToSignUpMode() throws {
        let toggleButton = app.buttons["Need an account? Sign Up"]
        XCTAssertTrue(toggleButton.waitForExistence(timeout: 5))

        toggleButton.tap()

        // After toggling, we should see "Create Account" header
        let createAccountText = app.staticTexts["Create Account"]
        XCTAssertTrue(
            createAccountText.waitForExistence(timeout: 3),
            "After toggling, 'Create Account' header should be visible."
        )

        // The button text should now offer to go back to login
        let loginToggle = app.buttons["Already have an account? Log In"]
        XCTAssertTrue(
            loginToggle.waitForExistence(timeout: 3),
            "The toggle should now show 'Already have an account? Log In'."
        )

        // The action button should say "Sign Up"
        let signUpButton = app.buttons["Sign Up"]
        XCTAssertTrue(
            signUpButton.waitForExistence(timeout: 3),
            "The action button should now say 'Sign Up'."
        )
    }

    /// Verifies toggling back from sign-up to login mode.
    @MainActor
    func testToggleBackToLoginMode() throws {
        // First go to sign-up mode
        let signUpToggle = app.buttons["Need an account? Sign Up"]
        XCTAssertTrue(signUpToggle.waitForExistence(timeout: 5))
        signUpToggle.tap()

        // Then toggle back to login mode
        let loginToggle = app.buttons["Already have an account? Log In"]
        XCTAssertTrue(loginToggle.waitForExistence(timeout: 3))
        loginToggle.tap()

        // Should be back to login
        let welcomeText = app.staticTexts["Welcome Back"]
        XCTAssertTrue(
            welcomeText.waitForExistence(timeout: 3),
            "After toggling back, 'Welcome Back' header should be visible."
        )
    }

    // MARK: - Auth Field Interaction

    /// Verifies the user can type into the Email field.
    @MainActor
    func testCanTypeInEmailField() throws {
        let emailField = app.textFields["Email"]
        XCTAssertTrue(emailField.waitForExistence(timeout: 5))

        emailField.tap()
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
        let passwordField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordField.waitForExistence(timeout: 5))

        passwordField.tap()
        passwordField.typeText("password123")

        // SecureField won't expose the actual value, but we verify no crash
        XCTAssertTrue(passwordField.exists, "Password field should still exist after typing.")
    }

    // MARK: - Launch Performance

    /// Measures how long it takes to launch the application.
    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
