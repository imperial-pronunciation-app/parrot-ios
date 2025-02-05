//
//  ParrotApiService.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 23/01/2025.
//

import Foundation

class ParrotApiService {
    private let baseURL = "https://" + (Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as! String) + "/api/v1"
    private let webService = WebService()
    
    enum ParrotApiError: Error, LocalizedError {
        case customError(String)
        
        var errorDescription: String? {
            switch self {
            case .customError(let message):
                return NSLocalizedString("Parrot API Error: \(message)", comment: message)
            }
        }
    }

    func getLeaderboard() async -> Result<LeaderboardResponse, ParrotApiError> {
        do {
            let leaderboardResponse: LeaderboardResponse = try await webService.downloadData(fromURL: baseURL + "/leaderboard/global")
            return .success(leaderboardResponse)
        } catch {
            return .failure(.customError("Failed to fetch the leaderboard."))
        }
    }
    
    func getRandomWord() async -> Result<Word, ParrotApiError> {
        do {
            let word: Word = try await webService.downloadData(fromURL: "\(baseURL)/random_word")
            return .success(word)
        } catch NetworkError.badStatus(let code, let data) {
            let dataString = String(data: data!, encoding: .utf8) ?? ""
            return .failure(.customError("API returned bad status: \(dataString)"))
        } catch {
            return .failure(.customError("Failed to fetch the word."))
        }
    }
    
    func getCurriculum() async -> Result<Curriculum, ParrotApiError> {
        do {
            let curriculum: Curriculum = try await webService.downloadData(fromURL: baseURL + "/units")
            return .success(curriculum)
        } catch {
            return .failure(.customError("Failed to fetch the curriculum."))
        }
    }
    
    func getExercise(excerciseId: Int) async -> Result<Exercise, ParrotApiError> {
        do {
            let exercise: Exercise = try await webService.downloadData(fromURL: baseURL + "/exercises/\(excerciseId)")
            return .success(exercise)
        } catch {
            return .failure(.customError("Failed to fetch the exercise."))
        }
    }
    
    func postRecording(recordingURL: URL, word: Word) async -> Result<RecordingResponse, ParrotApiError> {
        do {
            let audioFile = try Data(contentsOf: recordingURL)
            
            let formData: [MultiPartFormDataElement] = [
                MultiPartFormDataElement(name: "audio_file", filename: "recording.wav", contentType: "audio/wav", data: audioFile)
            ]
            
            let url = "\(baseURL)/words/\(word.word_id)/recording"
            let response: RecordingResponse = try await webService.postMultiPartFormData(data: formData, toURL: url)
            return .success(response)
        } catch {
            return .failure(.customError("Failed to upload recording."))
        }
    }
}
