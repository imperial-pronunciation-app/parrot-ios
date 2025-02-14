//
//  MockAssertions.swift
//  ParrotIos
//
//  Created by et422 on 12/02/2025.
//

protocol CallTracking: AnyObject {
    var callCounts: [String: Int] { get set } // Map method name to number of calls
    var callArguments: [String: [[Any?]]] { get set } // Map method name to ordered list of arguments
    var returnValues: [String: [Result<Any?, Error>]] { get set }  // Map method name to ordered list of return values

}


extension CallTracking {
    func incrementCallCount(for method: String) {
        callCounts[method, default: 0] += 1
    }

    func recordCallArguments(for method: String, with arguments: [Any?]) {
        callArguments[method, default: []].append(arguments)
    }

    func assertCallCount(for method: String, equals expectedCount: Int) {
        let actualCount = callCounts[method, default: 0]
        assert(
            actualCount == expectedCount,
            "Expected \(method) to be called \(expectedCount) times, but was called \(actualCount) times."
        )
    }
    
    func assertCallArguments(for method: String, at index: Int, matches expectedArguments: [Any?]) {
        guard let argumentsList = callArguments[method], argumentsList.count > index else {
            assertionFailure("No call recorded for \(method) at index \(index)")
            return
        }

        let actualArguments = argumentsList[index]
        assert(
            actualArguments.elementsEqual(expectedArguments, by: { $0 as? AnyHashable == $1 as? AnyHashable }),
            "Expected arguments for \(method) at index \(index) to be \(expectedArguments), but got \(actualArguments)"
        )
    }

    func stub<T>(method: String, toReturn value: T) {
        if returnValues[method] == nil {
            returnValues[method] = []
        }
        returnValues[method]?.append(.success(value))
    }
    
    func stub<T>(method: String, toReturnInOrder values: [T]) {
        let results = values.map { Result<Any?, Error>.success($0) }
        if returnValues[method] == nil {
            returnValues[method] = []
        }
        returnValues[method]?.append(contentsOf: results)
    }
    
    func stub(method: String, toThrow error: Error) {
        let result = Result<Any?, Error>.failure(error)
        if returnValues[method] == nil {
            returnValues[method] = []
        }
        returnValues[method]?.append(result)
    }
    
    func getReturnValue<T>(for method: String, callIndex: Int) throws -> T {
        guard let values = returnValues[method] else {
            throw MockError.noReturnValueStubbed(method: method)
        }

        let index = values.count == 1 ? 0 : callIndex
        guard index < values.count else {
            throw MockError.noMoreReturnValues(method: method, callIndex: callIndex)
        }

        let result = values[index]
        switch result {
        case .success(let value):
            guard let castedValue = value as? T else {
                throw MockError.incorrectReturnType(method: method, expected: String(describing: T.self))
            }
            return castedValue
        case .failure(let error):
            throw error
        }
    }
    
    func clear() {
        callCounts.removeAll()
        callArguments.removeAll()
        returnValues.removeAll()
    }
    
    func recordCall(for method: String, with arguments: [Any?]) {
        incrementCallCount(for: method)
        recordCallArguments(for: method, with: arguments)
    }
    
    func recordCall(for method: String) {
        recordCall(for: method, with: [])
    }

}

enum MockError: Error, CustomStringConvertible {
    case noReturnValueStubbed(method: String)
    case noMoreReturnValues(method: String, callIndex: Int)
    case incorrectReturnType(method: String, expected: String)
    
    var description: String {
        switch self {
        case .noReturnValueStubbed(let method):
            return "No return value stubbed for \(method)"
        case .noMoreReturnValues(let method, let callIndex):
            return "No more return values stubbed for \(method) at \(callIndex) calls"
        case .incorrectReturnType(let method, let expected):
            return "Incorrect return type subbed for \(method), expected \(expected)"
        }
    }
}
