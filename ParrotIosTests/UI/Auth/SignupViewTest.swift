//
//  SignupViewTest.swift
//  ParrotIosUITests
//
//  Created by Henry Yu on 11/2/2025.
//

import XCTest

final class SignupViewTest: XCTestCase {

    let app: XCUIApplication = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app.launch()
        app.buttons["Don't have an account?"].tap()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.terminate()
    }

    func testSignupFieldsDisplay() throws {
        let emailField = app.textFields["Email"]
        let passwordField = app.secureTextFields["Password"]
        let confirmPasswordField = app.secureTextFields["Confirm Password"]
        let registerButton = app.buttons["Register"]
        let loginLink = app.buttons["Already have an account?"]

        XCTAssertTrue(emailField.exists)
        XCTAssertTrue(passwordField.exists)
        XCTAssertTrue(confirmPasswordField.exists)
        XCTAssertTrue(registerButton.exists)
        XCTAssertTrue(loginLink.exists)
    }

    func testNavigationToLogin() throws {
        let loginLink = app.buttons["Already have an account?"]
        loginLink.tap()

        // Verify that we have navigated to login screen
        let loginButton = app.buttons["Login"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 5))
    }

    func testNavigationToHome() throws {
        // Mock a signup attempt with MockWebService
    }
}
