//
//  AuthServiceTest.swift
//  ParrotIosTests
//
//  Created by et422 on 11/02/2025.
//

import Testing

@testable import ParrotIos
import Foundation

@Suite("AuthService Tests", .serialized)
struct AuthServiceTests {
    var mockWebService: (WebServiceProtocol & CallTracking) = MockWebService() as (WebServiceProtocol & CallTracking)
    var authService: AuthService!

    init() {
        mockWebService.clear()
        authService = AuthService(webService: mockWebService)
        KeychainManager.instance.deleteToken(forKey: "access_token")
    }

    @Test("Auth service sets access token correctly after successful login")
    func testSuccessfulLogin() async throws {
        let username = "test@example.com"
        let password = "password123"
        let expectedToken = "fake_token"

        mockWebService.stub(method: WebServiceMethods.postURLEncodedFormData, toReturn: LoginAPIResponse(
            accessToken: expectedToken,
            tokenType: "bearer"
        ))

        mockWebService.stub(method: WebServiceMethods.get, toReturn: UserDetails(id: 1, loginStreak: 1))

        try #require(authService.getAccessToken() == nil)
        try #require(!authService.isAuthenticated)

        // Act
        try await authService.login(username: username, password: password)

        // Assert auth service state updated correctly
        #expect(authService.isAuthenticated)
        #expect(authService.getAccessToken() == expectedToken)

        // Verify correct parameters were sent
        let expectedParams = [
            FormDataURLEncodedElement(key: "username", value: username),
            FormDataURLEncodedElement(key: "password", value: password)
        ]
        let headers: [HeaderElement] = []
        #expect(mockWebService.callCounts(for: WebServiceMethods.postURLEncodedFormData) == 1)
        mockWebService.assertCallArguments(
            for: WebServiceMethods.postURLEncodedFormData,
            matches: [expectedParams, "\(authService.baseURL)/auth/jwt/login", headers])
    }

    @Test("Auth service fails properly on unsuccessful login (bad credentials)")
    func testLoginFailureBadCredentials() async throws {
        let username = "wrong@example.com"
        let password = "wrongpass"

        try #require(authService.getAccessToken() == nil)

        mockWebService.stub(method: WebServiceMethods.postURLEncodedFormData, toThrow: NetworkError.badStatus(
            code: 400,
            // swiftlint:disable:next force_try
            data: try! JSONEncoder().encode(LoginAPIErrorResponse(detail: .loginBadCredentials))
        ))

        // Act & Assert
        await #expect(throws: LoginError.badCredentials) {
            try await authService.login(username: username, password: password)
        }

        #expect(!authService.isAuthenticated)
        #expect(authService.getAccessToken() == nil)
    }

    @Test("Auth service deauthenticates itself properly on logout")
    func testLogoutSuccess() async throws {
        // Setup
        let username = "test@example.com"
        let password = "password123"
        let expectedToken = "fake_token"
        mockWebService.stub(method: WebServiceMethods.postURLEncodedFormData, toReturn: LoginAPIResponse(
            accessToken: expectedToken,
            tokenType: "bearer"
        ))
        mockWebService.stub(method: WebServiceMethods.get, toReturn: UserDetails(id: 1, loginStreak: 1))
        try await authService.login(username: username, password: password)

        mockWebService.stub(method: WebServiceMethods.postNoResponse, toReturn: ())

        // Act
        try await authService.logout()

        // Assert
        #expect(!authService.isAuthenticated)
        #expect(authService.getAccessToken() == "fake_token")

        // Verify correct headers were sent
        let expectedHeaders = [HeaderElement(key: "Authorization", value: "Bearer test_token")]
        #expect(mockWebService.callCounts(for: WebServiceMethods.postNoResponse) == 1)
        mockWebService.assertCallArguments(for: WebServiceMethods.postNoResponse, matches: ["\(authService.baseURL)/auth/jwt/logout", expectedHeaders])
    }

    @Test("Auth service fails to log out when not logged in")
    func testLogoutFailureNotLoggedIn() async throws {
        try #require(!authService.isAuthenticated)

        await #expect(throws: LogoutError.notLoggedIn) {
            try await authService.logout()
        }
    }

    @Test("Auth service registers properly")
    func testRegisterSuccess() async throws {
        // Arrange
        let email = "new@example.com"
        let password = "newpass123"

        mockWebService.stub(method: WebServiceMethods.postData, toReturn: RegisterAPIResponse(
            id: 1,
            email: email
        ))

        // Act
        try await authService.register(email: email, password: password)

        // Assert
        #expect(mockWebService.callCounts(for: WebServiceMethods.postData) == 1)

        // Verify the correct data was sent
        let expectedBody: [String: Any] = ["email": email, "password": password]
        let expectedData = try JSONSerialization.data(withJSONObject: expectedBody)
        mockWebService.assertCallArguments(for: WebServiceMethods.postData, matches: [expectedData, "\(authService.baseURL)/users/register", []])
    }

    @Test("Auth service fails to register if user already exists")
    func testRegisterFailureUserExists() async throws {
        // Arrange
        let email = "existing@example.com"
        let password = "pass123"

        mockWebService.stub(method: WebServiceMethods.postData, toThrow: NetworkError.badStatus(
            code: 400,
            // swiftlint:disable:next force_try
            data: try! JSONEncoder().encode(RegisterAPIErrorResponse(detail: .registerUserAlreadyExists))
        ))

        // Act & Assert
        async #expect(throws: RegisterError.userAlreadyExists) {
            try await authService.register(email: email, password: password)
        }
    }
}
