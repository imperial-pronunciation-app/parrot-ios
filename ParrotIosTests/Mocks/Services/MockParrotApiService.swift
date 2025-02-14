//
//  MockParrotApiService.swift
//  ParrotIosTests
//
//  Created by et422 on 14/02/2025.
//

import Foundation

@testable import ParrotIos

class MockParrotApiService: ParrotApiServiceProtocol, CallTracking {
    var callCounts: [String : Int] = [:]
    var callArguments: [String : [[Any?]]] = [:]
    var returnValues: [String : [Result<Any?, any Error>]] = [:]
    
    func getLeaderboard() async -> Result<ParrotIos.LeaderboardResponse, ParrotIos.ParrotApiError> {
        let method = "getLeaderboard"
        recordCall(for: method)
        
        do {
            return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
        } catch {
            fatalError("MockParrotApiService failed with error: \(error)")
        }
    }
    
    func getRandomWord() async -> Result<ParrotIos.Word, ParrotIos.ParrotApiError> {
        let method = "getRandomWord"
        recordCall(for: method)
        
        do {
            return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
        } catch {
            fatalError("MockParrotApiService failed with error: \(error)")
        }
    }
    
    func getCurriculum() async -> Result<ParrotIos.Curriculum, ParrotIos.ParrotApiError> {
        let method = "getCurriculum"
        recordCall(for: method)
        
        do {
            return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
        } catch {
            fatalError("MockParrotApiService failed with error: \(error)")
        }
    }
    
    func getExercise(exerciseId: Int) async -> Result<ParrotIos.Exercise, ParrotIos.ParrotApiError> {
        let method = "getExercise"
        recordCall(for: method, with: [exerciseId])
        
        do {
            return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
        } catch {
            fatalError("MockParrotApiService failed with error: \(error)")
        }
    }
    
    func postExerciseAttempt(recordingURL: URL, exercise: ParrotIos.Exercise) async -> Result<ParrotIos.AttemptResponse, ParrotIos.ParrotApiError> {
        let method = "postExerciseAttempt"
        recordCall(for: method, with: [recordingURL, exercise])
        
        do {
            return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
        } catch {
            fatalError("MockParrotApiService failed with error: \(error)")
        }
    }    
}
