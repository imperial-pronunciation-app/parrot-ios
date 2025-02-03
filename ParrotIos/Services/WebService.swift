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
    
    // MARK: - POST with no data
    func post<T: Codable>(toURL: String, headers: [HeaderElement] = []) async throws -> T {
        guard let url = URL(string: toURL) else { throw NetworkError.badUrl }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        for header in headers {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        let (responseData, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
        guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }
        guard let decodedResponse = try? JSONDecoder().decode(T.self, from: responseData) else { throw NetworkError.failedToDecodeResponse }

        return decodedResponse
    }
    
    // MARK: - POST for application/json type
    func postData<T: Codable>(data: Data, toURL: String) async throws -> T {
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
    
    // MARK: - POST for multipart/form-data
    func postMultiPartFormData<T: Codable>(data: [MultiPartFormDataElement], toURL: String) async throws -> T {
        // Create the request
        guard let url = URL(string: toURL) else { throw NetworkError.badUrl }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        for element in data {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(element.name)\"".data(using: .utf8)!)
            if let filename = element.filename {
                body.append("; filename=\"\(filename)\"".data(using: .utf8)!)
            }
            body.append("\r\n".data(using: .utf8)!)
            if let contentType = element.contentType {
                body.append("Content-Type: \(contentType)\r\n\r\n".data(using: .utf8)!)
            }
            body.append(element.data)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let(responseData, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
        guard response.statusCode >= 200 && response.statusCode < 300 else {
            print("Bad status code: \(response.statusCode)")
            throw NetworkError.badStatus
        }
        guard let decodedResponse = try? JSONDecoder().decode(T.self, from: responseData) else { throw NetworkError.failedToDecodeResponse }
        
        return decodedResponse
    }
    
    // MARK: - POST for application/x-www-form-urlencoded
    func postURLEncodedFormData<T: Codable>(parameters: [FormDataURLEncodedElement], toURL: String, headers: [HeaderElement] = []) async throws -> T {
        guard let url = URL(string: toURL) else { throw NetworkError.badUrl }
        print(url)
//        let formBody = parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
//        guard let formData = formBody.data(using: .utf8) else { throw NetworkError.failedToEncodeData }
        var formComponents = URLComponents()
        formComponents.queryItems = parameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
//        guard let formComponentsEncoded = formComponents.percentEncodedQuery else {
//            throw NetworkError.failedToEncodeData
//        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = formComponents.query?.data(using: .utf8)

        let (responseData, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
        //HERE

        guard response.statusCode >= 200 && response.statusCode < 300 else {
            print(request.httpBody!)
            print("Bad status code: \(response.statusCode)")
            print(responseData)
            throw NetworkError.badStatus
        }
        print("Previous recording removed.")

        guard let decodedResponse = try? JSONDecoder().decode(T.self, from: responseData) else { throw NetworkError.failedToDecodeResponse }

        return decodedResponse
    }
}

struct ErrorResponse: Codable {
    let error: String
    let message: String
}

struct MultiPartFormDataElement {
    let name: String
    let filename: String?
    let contentType: String?
    let data: Data
}

struct FormDataURLEncodedElement {
    let key: String
    let value: String
}

struct HeaderElement {
    let key: String
    let value: String
}

enum NetworkError: Error {
    case badUrl
    case invalidRequest
    case badResponse
    case badStatus
    case failedToDecodeResponse
    case failedToEncodeData
}
