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
    static let getRandomWord = "getRandomWord"
    static let getCurriculum = "getCurriculum"
    static let getExercise = "getExercise"
    static let postExerciseAttempt = "postExerciseAttempt"
}

class MockParrotApiService: ParrotApiServiceProtocol, CallTracking {
    var callCounts: [String : Int] = [:]
    var callArguments: [String : [[Any?]]] = [:]
    var returnValues: [String : [Result<Any?, any Error>]] = [:]
    
    func getLeaderboard() async throws -> LeaderboardResponse {
        let method = ParrotApiServiceMethods.getLeaderboard
        recordCall(for: method)
        return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
    }
    
    func getRandomWord() async throws -> ParrotIos.Word {
        let method = ParrotApiServiceMethods.getRandomWord
        recordCall(for: method)
        return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
    }
    
    func getCurriculum() async throws -> ParrotIos.Curriculum {
        let method = ParrotApiServiceMethods.getCurriculum
        recordCall(for: method)
        return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
    }
    
    func getExercise(exerciseId: Int) async throws -> ParrotIos.Exercise {
        let method = ParrotApiServiceMethods.getExercise
        recordCall(for: method, with: [exerciseId])
        return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
    }
    
    func postExerciseAttempt(recordingURL: URL, exercise: ParrotIos.Exercise) async throws -> ParrotIos.AttemptResponse {
        let method = ParrotApiServiceMethods.postExerciseAttempt
        recordCall(for: method, with: [recordingURL, exercise])
        return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
    }
}
