//
//  AuthServiceTest.swift
//  ParrotIosTests
//
//  Created by et422 on 11/02/2025.
//

import Testing

class AuthServiceTests {
    var mockWebService: MockWebService!
    var authService: AuthService!
    
    @Test
    func setup() {
        mockWebService = MockWebService()
        authService = AuthService(webService: mockWebService)
    }
    
    @Test
    func testSuccessfulLogin() async throws {
        // Arrange
        setup()
        let username = "test@example.com"
        let password = "password123"
        let expectedToken = "fake_token"
        
        mockWebService.stub(method: "postURLEncodedFormData", toReturn: LoginAPIResponse(
            access_token: expectedToken,
            token_type: "bearer"
        ))
        
        // Act
        try await authService.login(username: username, password: password)
        
        // Assert
        #expect(authService.isAuthenticated)
        #expect(authService.getAccessToken() == expectedToken)
        
        // Verify correct parameters were sent
        let expectedParams = [
            FormDataURLEncodedElement(key: "username", value: username),
            FormDataURLEncodedElement(key: "password", value: password)
        ]
        mockWebService.assertCallCount(for: "postURLEncodedFormData", equals: 1)
        mockWebService.assertCallArguments(for: "postURLEncodedFormData", at: 0, matches: [expectedParams, "\(authService.baseURL)/auth/jwt/login"])
    }
    
//    @Test
//    func testLoginFailureBadCredentials() async throws {
//        // Arrange
//        setup()
//        let username = "wrong@example.com"
//        let password = "wrongpass"
//        
//        mockWebService.stub(method: "postURLEncodedFormData", toThrow: NetworkError.badStatus(
//            code: 400,
//            data: try! JSONEncoder().encode(LoginAPIErrorResponse(detail: .LOGIN_BAD_CREDENTIALS))
//        ))
//        
//        // Act & Assert
//        do {
//            try await authService.login(username: username, password: password)
//            #fail("Login should have failed")
//        } catch let error as LoginError {
//            #expect(error == LoginError.badCredentials)
//            #expect(!authService.isAuthenticated)
//            #expect(authService.getAccessToken() == nil)
//        } catch {
//            #fail("Unexpected error type: \(error)")
//        }
//    }
//    
//    @Test
//    func testLogoutSuccess() async throws {
//        // Arrange
//        setup()
//        try authService.saveTokens(accessToken: "test_token")
//        mockWebService.stub(method: "postNoResponse", toReturn: ())
//        
//        // Act
//        try await authService.logout()
//        
//        // Assert
//        #expect(!authService.isAuthenticated)
//        
//        // Verify correct headers were sent
//        let expectedHeaders = [HeaderElement(key: "Authorization", value: "Bearer test_token")]
//        mockWebService.assertCallCount(for: "postNoResponse", equals: 1)
//        mockWebService.assertCallArguments(for: "postNoResponse", at: 0, matches: ["\(authService.baseURL)/auth/jwt/logout", expectedHeaders])
//    }
//    
//    @Test
//    func testLogoutFailureNotLoggedIn() async throws {
//        // Arrange
//        setup()
//        
//        // Act & Assert
//        do {
//            try await authService.logout()
//            #fail("Logout should have failed")
//        } catch let error as LogoutError {
//            #expect(error == LogoutError.notLoggedIn)
//        } catch {
//            #fail("Unexpected error type: \(error)")
//        }
//    }
//    
//    @Test
//    func testRegisterSuccess() async throws {
//        // Arrange
//        setup()
//        let email = "new@example.com"
//        let password = "newpass123"
//        
//        mockWebService.stub(method: "postData", toReturn: RegisterAPIResponse(
//            id: 1,
//            email: email
//        ))
//        
//        // Act
//        try await authService.register(email: email, password: password)
//        
//        // Assert
//        mockWebService.assertCallCount(for: "postData", equals: 1)
//        
//        // Verify the correct data was sent
//        let expectedBody: [String: Any] = ["email": email, "password": password]
//        let expectedData = try JSONSerialization.data(withJSONObject: expectedBody)
//        mockWebService.assertCallArguments(for: "postData", at: 0, matches: [expectedData, "\(authService.baseURL)/users/register", []])
//    }
//    
//    @Test
//    func testRegisterFailureUserExists() async throws {
//        // Arrange
//        setup()
//        let email = "existing@example.com"
//        let password = "pass123"
//        
//        mockWebService.stub(method: "postData", toThrow: NetworkError.badStatus(
//            code: 400,
//            data: try! JSONEncoder().encode(RegisterAPIErrorResponse(detail: .REGISTER_USER_ALREADY_EXISTS))
//        ))
//        
//        // Act & Assert
//        do {
//            try await authService.register(email: email, password: password)
//            #fail("Register should have failed")
//        } catch let error as RegisterError {
//            #expect(error == RegisterError.userAlreadyExists)
//        } catch {
//            #fail("Unexpected error type: \(error)")
//        }
//    }
}
