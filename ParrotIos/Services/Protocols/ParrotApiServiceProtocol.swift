//
//  ParrotApiServiceProtocol.swift
//  ParrotIos
//
//  Created by et422 on 14/02/2025.
//

import Foundation

protocol ParrotApiServiceProtocol {

    func getLeaderboard() async throws -> LeaderboardResponse

    func getCurriculum() async throws -> Curriculum

    func getExercise(exerciseId: Int) async throws -> Exercise

    func postExerciseAttempt(recordingURL: URL, exercise: Exercise) async throws -> AttemptResponse

    func getWordOfTheDay() async throws -> Word

    func postWordOfTheDayAttempt(recordingURL: URL) async throws -> AttemptResponse
}
