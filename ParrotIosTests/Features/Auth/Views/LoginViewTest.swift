//
//  LoginViewTest.swift
//  ParrotIosTests
//
//  Created by Henry Yu on 17/2/2025.
//

import SwiftUI
import XCTest
import ViewInspector

@testable import ParrotIos

final class LoginViewTest: XCTestCase {

    static let viewModel = MockViewModel()
    var sut = LoginView(viewModel: viewModel)
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        LoginViewTest.viewModel.clear()
    }

    @MainActor
    func testLoginAttempt() throws {
        let exp = sut.on(\.didAppear) { view in
            let username = "u@gmail.com"
            let password = "password"
            let usernameField = try view.find(ViewType.TextField.self, where: {
                try $0.labelView().text().string() == "Username"
            })
            let passwordField = try view.find(ViewType.SecureField.self, where: {
                try $0.labelView().text().string() == "Password"
            })
            try usernameField.setInput(username)
            try passwordField.setInput(password)
            let loginButton = try view.find(button: "Login")
            Task {
                try loginButton.tap()
                try await Task.sleep(nanoseconds: 100_000)  // Ensure async call completes
                XCTAssertEqual(LoginViewTest.viewModel.callCount(for: "login"), 1)
                LoginViewTest.viewModel.assertCallArguments(for: "login", at: 0, matches: [username, password])
            }
        }
        ViewHosting.host(view: sut)
        defer { ViewHosting.expel() }
        wait(for: [exp], timeout: 0.1)
    }

    class MockViewModel: LoginView.ViewModelProtocol, CallTracking {

        var callCounts: [String : Int] = [:]
        var callArguments: [String : [[Any?]]] = [:]
        var returnValues: [String : [Result<Any?, Error>]] = [:]
        var errorMessage: String?

        func login(username: String, password: String, succeed: Binding<Bool>) async {
            recordCall(for: "login", with: [username, password])
            succeed.wrappedValue = true
        }

        func logout() async {
            recordCall(for: "logout")
        }
    }
}
