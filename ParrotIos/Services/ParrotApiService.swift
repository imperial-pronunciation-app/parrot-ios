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
    private let authService = AuthService()
    
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
            guard let accessToken = authService.getAccessToken() else { throw LogoutError.notLoggedIn }
            let leaderboardResponse: LeaderboardResponse = try await webService.downloadData(
                fromURL: baseURL + "/leaderboard/global",
                headers: [generateAuthHeader(accessToken: accessToken)])
            return .success(leaderboardResponse)
        } catch {
            // TODO: Handle the case when user might not be logged in or missing token in keychain
            return .failure(.customError("Failed to fetch the leaderboard."))
        }
    }
    
    func getRandomWord() async -> Result<Word, ParrotApiError> {
        do {
            guard let accessToken = authService.getAccessToken() else { throw LogoutError.notLoggedIn }
            let word: Word = try await webService.downloadData(
                fromURL: "\(baseURL)/random_word",
                headers: [generateAuthHeader(accessToken: accessToken)])
            return .success(word)
        } catch NetworkError.badStatus(let code, let data) {
            let dataString = String(data: data!, encoding: .utf8) ?? ""
            return .failure(.customError("API returned bad status \(code): \(dataString)"))
        } catch {
            return .failure(.customError("Failed to fetch the word."))
        }
    }
    
    func getCurriculum() async -> Result<Curriculum, ParrotApiError> {
        do {
            guard let accessToken = authService.getAccessToken() else { throw LogoutError.notLoggedIn }
            let curriculum: Curriculum = try await webService.downloadData(
                fromURL: baseURL + "/units",
                headers: [generateAuthHeader(accessToken: accessToken)])
            return .success(curriculum)
        } catch NetworkError.badStatus(let code, let data) {
            return .failure(.customError("Bad status returned by /units."))
        } catch {
            return .failure(.customError("Failed to fetch the curriculum."))
        }
    }
    
    func getExercise(exerciseId: Int) async -> Result<Exercise, ParrotApiError> {
        do {
            guard let accessToken = authService.getAccessToken() else { throw LogoutError.notLoggedIn }
            let exercise: Exercise = try await webService.downloadData(
                fromURL: baseURL + "/exercises/\(exerciseId)",
                headers: [generateAuthHeader(accessToken: accessToken)])
            return .success(exercise)
        } catch {
            return .failure(.customError("Failed to fetch the exercise."))
        }
    }
    
    func postExerciseAttempt(recordingURL: URL, exercise: Exercise) async -> Result<AttemptResponse, ParrotApiError> {
        do {
            guard let accessToken = authService.getAccessToken() else { throw LogoutError.notLoggedIn }
            
            let audioFile = try Data(contentsOf: recordingURL)
            
            let formData: [MultiPartFormDataElement] = [
                MultiPartFormDataElement(name: "audio_file", filename: "recording.wav", contentType: "audio/wav", data: audioFile)
            ]
            
            let response: AttemptResponse = try await webService.postMultiPartFormData(
                data: formData,
                toURL: baseURL + "/exercises/\(exercise.id)/attempts",
                headers: [generateAuthHeader(accessToken: accessToken)])
            
            return .success(response)
        } catch NetworkError.badStatus(let code, let data) {
            return .failure(.customError("Bad status \(code)"))
        } catch {
            return .failure(.customError("Failed to get exercise feedback. \(error.localizedDescription)"))
        }
    }
    
    private func generateAuthHeader(accessToken: String) -> HeaderElement {
        return HeaderElement(key: "Authorization", value: "Bearer " + accessToken)
    }
}
