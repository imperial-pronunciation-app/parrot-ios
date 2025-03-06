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
    static let getExercise = "getExercise"
    static let postExerciseAttempt = "postExerciseAttempt"
    static let getWordOfTheDay = "getWordOfTheDay"
    static let postWordOfTheDayAttempt = "postWordOfTheDayAttempt"
}

class MockParrotApiService: ParrotApiServiceProtocol, CallTracking {
    func getUserDetails() async throws -> ParrotIos.UserDetails {
        return UserDetails(id: 1, loginStreak: 1, xpTotal: 1, email: "", displayName: "", language: Language(id: 1, code: "", name: ""), league: "", avatar: "")
    }

    func getLanguages() async throws -> [ParrotIos.Language] {
        return []
    }

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

    func getExercise(exerciseId: Int) async throws -> ParrotIos.Exercise {
        let method = ParrotApiServiceMethods.getExercise
        recordCall(for: method, with: [exerciseId])
        return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
    }

    func postExerciseAttempt(recordingURL: URL, exercise: ParrotIos.Exercise) async throws -> ParrotIos.ExerciseAttempt {
        let method = ParrotApiServiceMethods.postExerciseAttempt
        recordCall(for: method, with: [recordingURL, exercise])
        return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
    }

    func getWordOfTheDay() async throws -> ParrotIos.Word {
        let method = ParrotApiServiceMethods.getWordOfTheDay
        recordCall(for: method)
        return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
    }

    func postWordOfTheDayAttempt(recordingURL: URL) async throws -> ParrotIos.Attempt {
        let method = ParrotApiServiceMethods.postWordOfTheDayAttempt
        recordCall(for: method, with: [recordingURL])
        return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
    }
}
