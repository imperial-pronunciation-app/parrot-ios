//
//  ParrotApiService.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 23/01/2025.
//

import Foundation

class ParrotApiService: ParrotApiServiceProtocol {
    internal let baseURL = getBaseUrl() + "/api/v1"
    private let webService: WebServiceProtocol
    private let authService: AuthServiceProtocol

    init(webService: WebServiceProtocol = WebService(), authService: AuthServiceProtocol = AuthService.instance) {
        self.webService = webService
        self.authService = authService
    }

    private func getData<T: Codable>(endpoint: String) async throws -> T {
        guard let accessToken = authService.getAccessToken() else { throw ParrotApiError.notLoggedIn }
        do {
            let response: T = try await webService.get(
                fromURL: baseURL + endpoint,
                headers: [generateAuthHeader(accessToken: accessToken)])
            return response
        } catch NetworkError.badStatus(let code, _) {
            throw ParrotApiError.badStatus(code: code, endpoint: endpoint)
        }
    }

    func getUserDetails() async throws -> UserDetails {
        return try await getData(endpoint: "/user_details")
    }

    func getLanguages() async throws -> [Language] {
        return try await getData(endpoint: "/languages")
    }

    func getLeaderboard() async throws -> LeaderboardResponse {
        return try await getData(endpoint: "/leaderboard/global")
    }

    func getCurriculum() async throws -> Curriculum {
        return try await getData(endpoint: "/units")
    }

    func getLesson(lessonId: Int) async throws -> Lesson {
        return try await getData(endpoint: "/lessons/\(lessonId)")
    }

    func getExercise(exerciseId: Int) async throws -> Exercise {
        return try await getData(endpoint: "/exercises/\(exerciseId)")
    }

    func postExerciseAttempt(recordingURL: URL, exercise: Exercise) async throws -> ExerciseAttempt {
        guard let accessToken = authService.getAccessToken() else { throw LogoutError.notLoggedIn }

        let audioFile = try Data(contentsOf: recordingURL)

        let formData: [MultiPartFormDataElement] = [
            MultiPartFormDataElement(
                name: "audio_file",
                filename: "recording.wav",
                contentType: "audio/wav",
                data: audioFile)
        ]

        let response: ExerciseAttempt = try await webService.postMultiPartFormData(
            data: formData,
            toURL: baseURL + "/exercises/\(exercise.id)/attempts",
            headers: [generateAuthHeader(accessToken: accessToken)])

        return response
    }

    func getWordOfTheDay() async throws -> Word {
        return try await getData(endpoint: "/word_of_day")
    }

    func postWordOfTheDayAttempt(recordingURL: URL) async throws -> Attempt {
        guard let accessToken = authService.getAccessToken() else { throw LogoutError.notLoggedIn }

        let audioFile = try Data(contentsOf: recordingURL)

        let formData: [MultiPartFormDataElement] = [
            MultiPartFormDataElement(
                name: "audio_file",
                filename: "recording.wav",
                contentType: "audio/wav",
                data: audioFile)
        ]

        let response: Attempt = try await webService.postMultiPartFormData(
            data: formData,
            toURL: baseURL + "/word_of_day/attempts",
            headers: [generateAuthHeader(accessToken: accessToken)])

        return response
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
