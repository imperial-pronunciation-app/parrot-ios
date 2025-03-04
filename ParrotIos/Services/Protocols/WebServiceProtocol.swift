//
//  WebServiceProtocol.swift
//  ParrotIos
//
//  Created by et422 on 11/02/2025.
//

import Foundation

protocol WebServiceProtocol {
    
    func download(fromURL: String, headers: [HeaderElement]) async throws -> URL
    
    func get<T: Codable>(fromURL: String, headers: [HeaderElement]) async throws -> T
    
    func post<T: Codable>(toURL: String, headers: [HeaderElement]) async throws -> T
    
    func postNoResponse(toURL: String, headers: [HeaderElement]) async throws
    
    func postData<T: Codable>(data: Data, toURL: String, headers: [HeaderElement]) async throws -> T
    
    func postMultiPartFormData<T: Codable>(
        data: [MultiPartFormDataElement],
        toURL: String,
        headers: [HeaderElement]) async throws -> T
    
    func postURLEncodedFormData<T: Codable>(
        parameters: [FormDataURLEncodedElement],
        toURL: String,
        headers: [HeaderElement]) async throws -> T
}

extension WebServiceProtocol {
    func get<T: Codable>(fromURL: String) async throws -> T {
        try await get(fromURL: fromURL, headers: [])
    }
    func post<T: Codable>(toURL: String) async throws -> T {
        try await post(toURL: toURL, headers: [])
    }
    func postNoResponse(toURL: String) async throws {
        try await postNoResponse(toURL: toURL, headers: [])
    }
    func postData<T: Codable>(data: Data, toURL: String) async throws -> T {
        try await postData(data: data, toURL: toURL, headers: [])
    }
    func postMultiPartFormData<T: Codable>(
        data: [MultiPartFormDataElement],
        toURL: String) async throws -> T {
            try await postMultiPartFormData(data: data, toURL: toURL, headers: [])
        }
    func postURLEncodedFormData<T: Codable>(
        parameters: [FormDataURLEncodedElement],
        toURL: String) async throws -> T {
            try await postURLEncodedFormData(parameters: parameters, toURL: toURL, headers: [])
        }
}
