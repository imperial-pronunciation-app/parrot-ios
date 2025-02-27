//
//  MockParrotApiService.swift
//  ParrotIosTests
//
//  Created by et422 on 14/02/2025.
//

import Foundation

@testable import ParrotIos

struct ParrotApiServiceMethods {
    static let getLeaderboard = "getLeaderboard"
    static let getCurriculum = "getCurriculum"
    static let getLesson = "getLesson"
    static let postExerciseAttempt = "postExerciseAttempt"
    static let getWordOfTheDay = "getWordOfTheDay"
    static let postWordOfTheDayAttempt = "postWordOfTheDayAttempt"
}

class MockParrotApiService: ParrotApiServiceProtocol, CallTracking {
    var callCounts: [String: Int] = [:]
    var callArguments: [String: [[Any?]]] = [:]
    var returnValues: [String: [Result<Any?, any Error>]] = [:]

    func getLeaderboard() async throws -> LeaderboardResponse {
        let method = ParrotApiServiceMethods.getLeaderboard
        recordCall(for: method)
        return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
    }

    func getCurriculum() async throws -> ParrotIos.Curriculum {
        let method = ParrotApiServiceMethods.getCurriculum
        recordCall(for: method)
        return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
    }

    func getLesson(lessonId: Int) async throws -> ParrotIos.Lesson {
        let method = ParrotApiServiceMethods.getLesson
        recordCall(for: method, with: [lessonId])
        return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
    }

    func postExerciseAttempt(recordingURL: URL, exercise: ParrotIos.Exercise) async throws -> ParrotIos.AttemptResponse {
        let method = ParrotApiServiceMethods.postExerciseAttempt
        recordCall(for: method, with: [recordingURL, exercise])
        return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
    }

    func getWordOfTheDay() async throws -> ParrotIos.Word {
        let method = ParrotApiServiceMethods.getWordOfTheDay
        recordCall(for: method)
        return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
    }

    func postWordOfTheDayAttempt(recordingURL: URL) async throws -> ParrotIos.AttemptResponse {
        let method = ParrotApiServiceMethods.postExerciseAttempt
        recordCall(for: method, with: [recordingURL])
        return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
    }
}
