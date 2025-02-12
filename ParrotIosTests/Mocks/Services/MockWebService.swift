//
//  MockWebService.swift
//  ParrotIosTests
//
//  Created by et422 on 11/02/2025.
//

import Foundation

@testable import ParrotIos

class MockWebService: WebServiceProtocol, CallTracking {
    var callCounts: [String : Int] = [:]
    var callArguments: [String : [[Any?]]] = [:]
    var returnValues: [String : [Result<Any?, Error>]] = [:]
    
    func downloadData<T>(
        fromURL: String,
        headers: [HeaderElement]
    ) async throws -> T where T: Decodable & Encodable {
        let funcName = "downloadData"
        incrementCallCount(for: funcName)
        recordCallArguments(for: funcName, arguments: [fromURL, headers])
        
        return try getReturnValue(for: funcName, callIndex: callCounts[funcName]! - 1)
    }
    
    func post<T>(
        toURL: String,
        headers: [HeaderElement] = []
    ) async throws -> T where T: Decodable & Encodable {
        let funcName = "post"
        incrementCallCount(for: funcName)
        recordCallArguments(for: funcName, arguments: [toURL, headers])
        
        return try getReturnValue(for: funcName, callIndex: callCounts[funcName]! - 1)
    }
    
    func postNoResponse(
        toURL: String,
        headers: [HeaderElement] = []
    ) async throws {
        let funcName = "postNoResponse"
        incrementCallCount(for: funcName)
        recordCallArguments(for: funcName, arguments: [toURL, headers])
        
        return try getReturnValue(for: funcName, callIndex: callCounts[funcName]! - 1)

    }
    
    func postData<T>(
        data: Data,
        toURL: String,
        headers: [HeaderElement] = []
    ) async throws -> T where T: Decodable & Encodable {
        let funcName = "postData"
        incrementCallCount(for: funcName)
        recordCallArguments(for: funcName, arguments: [data, toURL, headers])
        
        return try getReturnValue(for: funcName, callIndex: callCounts[funcName]! - 1)

    }
    
    func postMultiPartFormData<T>(
        data: [MultiPartFormDataElement],
        toURL: String,
        headers: [HeaderElement] = []
    ) async throws -> T where T: Decodable & Encodable {
        let funcName = "postMultiPartFormData"
        incrementCallCount(for: funcName)
        recordCallArguments(for: funcName, arguments: [data, toURL, headers])
        
        return try getReturnValue(for: funcName, callIndex: callCounts[funcName]! - 1)

    }
    
    func postURLEncodedFormData<T>(
        parameters: [FormDataURLEncodedElement],
        toURL: String,
        headers: [HeaderElement] = []
    ) async throws -> T where T: Decodable & Encodable {
        let funcName = "postURLEncodedFormData"
        incrementCallCount(for: funcName)
        recordCallArguments(for: funcName, arguments: [parameters, toURL, headers])
        
        return try getReturnValue(for: funcName, callIndex: callCounts[funcName]! - 1)
    }
}

