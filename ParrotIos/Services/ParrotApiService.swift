//
//  ParrotApiService.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 23/01/2025.
//

import Foundation

class ParrotApiService {
    private let baseUrl = "https://pronunciation-app-backend.doc.ic.ac.uk/api/v1/"
    private let webService = WebService()
    
    enum ParrotApiError: Error {
        case customError(String)
    }
    
    func getRandomWord() async -> Result<Word, ParrotApiError> {
        do {
            let word: Word = try await webService.downloadData(fromURL: baseUrl + "random_word")
            return .success(word)
        } catch {
            return .failure(.customError("Failed to fetch the word."))
        }
    }
    
    func getCurriculum() async -> Result<Curriculum, ParrotApiError> {
        do {
            let curriculum: Curriculum = try await webService.downloadData(fromURL: baseUrl + "units")
            return .success(curriculum)
        } catch {
            return .failure(.customError("Failed to fetch the curriculum."))
        }
    }
    
    func getExercise(excerciseId: Int) async -> Result<Exercise, ParrotApiError> {
        do {
            let exercise: Exercise = try await webService.downloadData(fromURL: baseUrl + "exercises/\(excerciseId)")
            return .success(exercise)
        } catch {
            return .failure(.customError("Failed to fetch the exercise."))
        }
    }
    
    func postRecording(recordingURL: URL, word: Word) async -> Result<RecordingResponse, ParrotApiError> {
        do {
            let audioFile = try Data(contentsOf: recordingURL)
            
            let formData: [FormDataElement] = [
                FormDataElement(name: "audio_file", filename: "recording.wav", contentType: "audio/wav", data: audioFile)
            ]
            
            let url = baseUrl + "/words/\(word.word_id)/recording"
            let response: RecordingResponse = try await webService.postFormData(data: formData, toURL: url)
            return .success(response)
        } catch {
            return .failure(.customError("Failed to upload recording."))
        }
    }
}
