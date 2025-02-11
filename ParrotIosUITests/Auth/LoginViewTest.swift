//
//  LoginViewTest.swift
//  ParrotIosUITests
//
//  Created by Henry Yu on 11/2/2025.
//

import XCTest

final class LoginViewTest: XCTestCase {

    let app: XCUIApplication = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.terminate()
    }

    func testLoginFieldsDisplay() throws {
        let usernameField = app.textFields["Username"]
        let passwordField = app.secureTextFields["Password"]
        let loginButton = app.buttons["Login"]
        let signupLink = app.buttons["Don't have an account?"]

        XCTAssertTrue(usernameField.exists)
        XCTAssertTrue(passwordField.exists)
        XCTAssertTrue(loginButton.exists)
        XCTAssertTrue(signupLink.exists)
    }

    func testNavigationToSignup() throws {
        let signupLink = app.buttons["Don't have an account?"]
        signupLink.tap()
        
        // Verify that we have navigated to signup screen
        let registerButton = app.buttons["Register"]
        XCTAssertTrue(registerButton.waitForExistence(timeout: 5))
    }
    
    func testNavigationToHome() throws {
        // Mock a login attempt with MockWebService
    }
}
