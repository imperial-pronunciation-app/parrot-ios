//
//  ParrotApiServiceTest.swift
//  ParrotIosTests
//
//  Created by et422 on 11/02/2025.
//

import Testing

@testable import ParrotIos
import Foundation

@Suite("ParrotApiService Tests", .serialized)
struct ParrotApiServiceTests {
    var mockWebService: (WebServiceProtocol & CallTracking) = MockWebService() as (WebServiceProtocol & CallTracking)
    var mockAuthService: (AuthServiceProtocol & CallTracking) = MockAuthService() as (AuthServiceProtocol & CallTracking)
    var parrotApiService: ParrotApiService!

    let testAccessToken = "test_access_token"
    let expectedAuthHeader = HeaderElement(key: "Authorization", value: "Bearer test_access_token")

    init() {
        mockWebService.clear()
        mockAuthService.clear()
        parrotApiService = ParrotApiService(webService: mockWebService, authService: mockAuthService)
    }

    @Test("Get leaderboard returns success with valid response")
    func testGetLeaderboardSuccess() async throws {
        // Arrange
        let expectedResponse = LeaderboardResponse(league: "test", daysUntilEnd: 2, leaders: [User(id: 1, rank: 1, displayName: "a", xp: 1)], userPosition: [User(id: 1, rank: 1, displayName: "a", xp: 1)])
        mockAuthService.stub(method: AuthServiceMethods.getAccessToken, toReturn: testAccessToken)
        mockWebService.stub(method: WebServiceMethods.get, toReturn: expectedResponse)

        // Act
        let result = try await parrotApiService.getLeaderboard()

        #expect(result == expectedResponse)
        #expect(mockWebService.callCounts(for: WebServiceMethods.get) == 1)
        mockWebService.assertCallArguments(for: WebServiceMethods.get, matches: [
            "\(parrotApiService.baseURL)/leaderboard/global",
            [expectedAuthHeader]
        ])
    }

    @Test("Get leaderboard fails when not authenticated")
    func testGetLeaderboardNotAuthenticated() async throws {
        // Arrange
        mockAuthService.stub(method: AuthServiceMethods.getAccessToken, toReturn: nil as String?)

        // Assert
        await #expect(throws: ParrotApiError.notLoggedIn) {
            // Act
            _ = try await parrotApiService.getLeaderboard()
        }
    }

    @Test("Get word of the day returns success with valid response")
    func testGetWordOfTheDaySuccess() async throws {
        // Arrange
        mockAuthService.stub(method: AuthServiceMethods.getAccessToken, toReturn: testAccessToken)
        let expectedWord = Word(id: 1, text: "a", phonemes: [Phoneme(id: 1, ipa: "a", respelling: "a")])
        mockWebService.stub(method: WebServiceMethods.get, toReturn: expectedWord)

        // Act
        let result = try await parrotApiService.getWordOfTheDay()

        // Assert
        #expect(result == expectedWord)

        #expect(mockWebService.callCounts(for: WebServiceMethods.get) == 1)
        mockWebService.assertCallArguments(for: WebServiceMethods.get, matches: [
            "\(parrotApiService.baseURL)/word_of_day",
            [expectedAuthHeader]
        ])
    }

    @Test("Get curriculum returns success with valid response")
    func testGetCurriculumSuccess() async throws {
        // Arrange
        mockAuthService.stub(method: AuthServiceMethods.getAccessToken, toReturn: testAccessToken)
        let expectedCurriculum = Curriculum(units: [
            Unit(id: 1, name: "test", description: "desc", lessons: [
                ListedLesson(id: 1, title: "lesson", isCompleted: false, isLocked: false)
            ], recapLesson: nil, isCompleted: false, isLocked: false)
        ])
        mockWebService.stub(method: WebServiceMethods.get, toReturn: expectedCurriculum)

        // Act
        let result = try await parrotApiService.getCurriculum()

        // Assert
        #expect(result == expectedCurriculum)
        #expect(mockWebService.callCounts(for: WebServiceMethods.get) == 1)
        mockWebService.assertCallArguments(for: WebServiceMethods.get, matches: [
            "\(parrotApiService.baseURL)/units",
            [expectedAuthHeader]
        ])
    }

    @Test("Post exercise attempt returns success with valid response")
    func testPostExerciseAttemptSuccess() async throws {
        // Arrange
        mockAuthService.stub(method: AuthServiceMethods.getAccessToken, toReturn: testAccessToken)
        let exercise = Exercise(id: 1, word: Word(id: 1, text: "a", phonemes: [Phoneme(id: 1, ipa: "a", respelling: "a")]), isCompleted: false)
        let recordingURL = FileManager.default.temporaryDirectory.appendingPathComponent("test_recording.wav")
        let testAudioData = Data("test audio data".utf8)
        try testAudioData.write(to: recordingURL)

        let expectedResponse = ExerciseAttempt(
            success: true,
            recordingId: 1,
            score: 1,
            phonemes: [
                (Phoneme(id: 5, ipa: "m'", respelling: "m"), Phoneme(id: 5, ipa: "m'", respelling: "m")),
                (Phoneme(id: 6, ipa: "aʊ", respelling: "ow"), nil),
                (nil, Phoneme(id: 7, ipa: "s", respelling: "s"))
            ],
            xpGain: 2,
            exerciseIsCompleted: false
        )
        mockWebService.stub(method: WebServiceMethods.postMultiPartFormData, toReturn: expectedResponse)

        // Act
        let result = try await parrotApiService.postExerciseAttempt(recordingURL: recordingURL, exercise: exercise)

        // Assert
        #expect(result == expectedResponse)
        #expect(mockWebService.callCounts(for: WebServiceMethods.postMultiPartFormData) == 1)

        // Clean up
        try FileManager.default.removeItem(at: recordingURL)
    }
//    
//    @Test("Exercise attempt fails with bad status")
//    func testPostExerciseAttemptBadStatus() async throws {
//        // Arrange
//        let exercise = Exercise(id: 1, title: "Greetings", instructions: "Say hello")
//        let recordingURL = FileManager.default.temporaryDirectory.appendingPathComponent("test_recording.wav")
//        let testAudioData = "test audio data".data(using: .utf8)!
//        try testAudioData.write(to: recordingURL)
//        
//        mockWebService.stub(method: "postMultiPartFormData", toThrow: NetworkError.badStatus(
//            code: 400,
//            data: "Bad request".data(using: .utf8)
//        ))
//        
//        // Act
//        let result = await parrotApiService.postExerciseAttempt(recordingURL: recordingURL, exercise: exercise)
//        
//        // Assert
//        switch result {
//        case .success:
//            throw TestFailure("Expected failure but got success")
//        case .failure(let error):
//            #expect(error.localizedDescription.contains("Bad status 400"))
//        }
//        
//        // Clean up
//        try FileManager.default.removeItem(at: recordingURL)
//    }
}
