//
//  ParrotApiServiceProtocol.swift
//  ParrotIos
//
//  Created by et422 on 14/02/2025.
//

import Foundation

protocol ParrotApiServiceProtocol {
    
    func getLeaderboard() async -> Result<LeaderboardResponse, ParrotApiError>
    
    func getRandomWord() async -> Result<Word, ParrotApiError>
    
    func getCurriculum() async -> Result<Curriculum, ParrotApiError>
    
    func getExercise(exerciseId: Int) async -> Result<Exercise, ParrotApiError>
    
    func postExerciseAttempt(recordingURL: URL, exercise: Exercise) async -> Result<AttemptResponse, ParrotApiError>
}
