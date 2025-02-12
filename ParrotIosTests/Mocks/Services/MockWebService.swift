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
    var returnValues: [String : [Any?]] = [:]
    
    func downloadData<T>(
        fromURL: String,
        headers: [HeaderElement]
    ) async throws -> T where T: Decodable & Encodable {
        let funcName = "downloadData"
        incrementCallCount(for: funcName)
        recordCallArguments(for: funcName, arguments: [fromURL, headers])
        
        do {
            return try getReturnValue(for: funcName, callIndex: callCounts[funcName]! - 1)
        } catch {
            fatalError("MockWebService failed with error: \(error)")
        }
    }
    
    func post<T>(
        toURL: String,
        headers: [HeaderElement] = []
    ) async throws -> T where T: Decodable & Encodable {
        let funcName = "post"
        incrementCallCount(for: funcName)
        recordCallArguments(for: funcName, arguments: [toURL, headers])
        
        do {
            return try getReturnValue(for: funcName, callIndex: callCounts[funcName]! - 1)
        } catch {
            fatalError("MockWebService failed with error: \(error)")
        }
    }
    
    func postNoResponse(
        toURL: String,
        headers: [HeaderElement] = []
    ) async throws {
        let funcName = "postNoResponse"
        incrementCallCount(for: funcName)
        recordCallArguments(for: funcName, arguments: [toURL, headers])
        
        do {
            return try getReturnValue(for: funcName, callIndex: callCounts[funcName]! - 1)
        } catch {
            fatalError("MockWebService failed with error: \(error)")
        }
    }
    
    func postData<T>(
        data: Data,
        toURL: String,
        headers: [HeaderElement] = []
    ) async throws -> T where T: Decodable & Encodable {
        let funcName = "postData"
        incrementCallCount(for: funcName)
        recordCallArguments(for: funcName, arguments: [data, toURL, headers])
        
        do {
            return try getReturnValue(for: funcName, callIndex: callCounts[funcName]! - 1)
        } catch {
            fatalError("MockWebService failed with error: \(error)")
        }
    }
    
    func postMultiPartFormData<T>(
        data: [MultiPartFormDataElement],
        toURL: String,
        headers: [HeaderElement] = []
    ) async throws -> T where T: Decodable & Encodable {
        let funcName = "postMultiPartFormData"
        incrementCallCount(for: funcName)
        recordCallArguments(for: funcName, arguments: [data, toURL, headers])
        
        do {
            return try getReturnValue(for: funcName, callIndex: callCounts[funcName]! - 1)
        } catch {
            fatalError("MockWebService failed with error: \(error)")
        }
    }
    
    func postURLEncodedFormData<T>(
        parameters: [FormDataURLEncodedElement],
        toURL: String,
        headers: [HeaderElement] = []
    ) async throws -> T where T: Decodable & Encodable {
        let funcName = "postURLEncodedFormData"
        incrementCallCount(for: funcName)
        recordCallArguments(for: funcName, arguments: [parameters, toURL, headers])
        
        do {
            return try getReturnValue(for: funcName, callIndex: callCounts[funcName]! - 1)
        } catch {
            fatalError("MockWebService failed with error: \(error)")
        }
    }
}

