//
//  WebService.swift
//  ParrotIos
//
//  Created by James Watling on 22/01/2025.
//

import Foundation

class WebService {
    func downloadData<T: Codable>(fromURL: String) async throws -> T {
        guard let url = URL(string: fromURL) else { throw NetworkError.badUrl }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
        guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }
        guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else { throw NetworkError.failedToDecodeResponse }
                
        return decodedResponse
    }
    
    func postData<T: Codable>(data: Data, toURL: String) async throws -> T {
        // Create the request
        guard let url = URL(string: toURL) else { throw NetworkError.badUrl }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        let(responseData, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
        guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }
        guard let decodedResponse = try? JSONDecoder().decode(T.self, from: responseData) else { throw NetworkError.failedToDecodeResponse }
        
        return decodedResponse
    }
}

enum NetworkError: Error {
    case badUrl
    case invalidRequest
    case badResponse
    case badStatus
    case failedToDecodeResponse
}
