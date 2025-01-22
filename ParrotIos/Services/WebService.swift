//
//  WebService.swift
//  ParrotIos
//
//  Created by James Watling on 22/01/2025.
//

import Foundation

class WebService {
    func downloadData<T: Codable>(fromURL: String) async -> T? {
        do {
            guard let url = URL(string: fromURL) else { throw NetworkError.badUrl }
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
            guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }
            guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else { throw NetworkError.failedToDecodeResponse }
                    
            return decodedResponse
        } catch NetworkError.badUrl {
            print("Error creating the URL.")
        } catch NetworkError.badResponse {
            print("Did not receive a valid response.")
        } catch NetworkError.badStatus {
            print("Did not receive a 2xx status from the response.")
        } catch NetworkError.failedToDecodeResponse {
            print("Failed to decode response into the given type.")
        } catch {
            print("An error occured when downloading the data.")
        }
        
        return nil
    }
}

enum NetworkError: Error {
    case badUrl
    case invalidRequest
    case badResponse
    case badStatus
    case failedToDecodeResponse
}
