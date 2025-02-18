//
//  ParrotApiService.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 23/01/2025.
//

import Foundation

class ParrotApiService: ParrotApiServiceProtocol {
    internal let baseURL = "https://" + (Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as! String) + "/api/v1"
    private let webService: WebServiceProtocol
    private let authService: AuthServiceProtocol
    
    init(webService: WebServiceProtocol = WebService(), authService: AuthServiceProtocol = AuthService()) {
        self.webService = webService
        self.authService = authService
    }
    
    private func getData<T: Codable>(endpoint: String) async throws -> T {
        guard let accessToken = authService.getAccessToken() else { throw ParrotApiError.notLoggedIn }
        do {
            let response: T = try await webService.downloadData(
                fromURL: baseURL + endpoint,
                headers: [generateAuthHeader(accessToken: accessToken)])
            return response
        } catch NetworkError.badStatus(let code, _) {
            throw ParrotApiError.badStatus(code: code, endpoint: endpoint)
        }
    }

    func getLeaderboard() async throws -> LeaderboardResponse {
        return try await getData(endpoint: "/leaderboard/global")
    }
    
    func getRandomWord() async throws -> Word {
        return try await getData(endpoint: "/random_word")
        
    }
    
    func getCurriculum() async throws -> Curriculum {
        return try await getData(endpoint: "/units")
    }
    
    func getExercise(exerciseId: Int) async throws -> Exercise {
        return try await getData(endpoint: "/exercises/\(exerciseId)")
    }
    
    func postExerciseAttempt(recordingURL: URL, exercise: Exercise) async throws -> AttemptResponse {
        guard let accessToken = authService.getAccessToken() else { throw LogoutError.notLoggedIn }
            
        let audioFile = try Data(contentsOf: recordingURL)
            
        let formData: [MultiPartFormDataElement] = [
            MultiPartFormDataElement(name: "audio_file", filename: "recording.wav", contentType: "audio/wav", data: audioFile)
        ]
            
        let response: AttemptResponse = try await webService.postMultiPartFormData(
            data: formData,
            toURL: baseURL + "/exercises/\(exercise.id)/attempts",
            headers: [generateAuthHeader(accessToken: accessToken)])
            
        return response
    }
    
    private func generateAuthHeader(accessToken: String) -> HeaderElement {
        return HeaderElement(key: "Authorization", value: "Bearer " + accessToken)
    }
}

enum ParrotApiError: Error, LocalizedError, Equatable {
    case notLoggedIn
    case badStatus(code: Int, endpoint: String)
    
    var errorDescription: String? {
        switch self {
        case .notLoggedIn:
            return "Parrot API Error: Not Logged In"
        case .badStatus(let code, let endpoint):
            return "Parrot API Error: Bad status  \(code) returned by \(endpoint)."
        }
    }
}
