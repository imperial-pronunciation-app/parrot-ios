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

    func addCallArguments(for method: String, with arguments: [Any?]) {
        callArguments[method, default: []].append(arguments)
    }

    func callCounts(for method: String) -> Int {
        return callCounts[method, default: 0]
    }

    func assertCallArguments(for method: String, matches expectedArguments: [Any?]) {
        guard let actualArguments = callArguments[method]?.first else {
            assertionFailure("No more call(s) recorded for \(method)")
            return
        }

        callArguments[method]?.removeFirst()

        assert(
            actualArguments.elementsEqual(expectedArguments, by: { $0 as? AnyHashable == $1 as? AnyHashable }),
            "Expected arguments for \(method) at to be \(expectedArguments), but got \(actualArguments)"
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
            throw MockError.noReturnValueStubbed(method: method.description)
        }

        let index = values.count == 1 ? 0 : callIndex
        guard index < values.count else {
            throw MockError.noMoreReturnValues(method: method.description)
        }

        let result = values[index]
        switch result {
        case .success(let value):
            guard let castedValue = value as? T else {
                throw MockError.incorrectReturnType(method: method.description, expected: String(describing: T.self))
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
        addCallArguments(for: method, with: arguments)
    }

    func recordCall(for method: String) {
        recordCall(for: method, with: [])
    }

}

enum MockError: Error, CustomStringConvertible {
    case noReturnValueStubbed(method: String)
    case noMoreReturnValues(method: String)
    case incorrectReturnType(method: String, expected: String)

    var description: String {
        switch self {
        case .noReturnValueStubbed(let method):
            return "No return value stubbed for \(method)"
        case .noMoreReturnValues(let method):
            return "No more return values stubbed for \(method)"
        case .incorrectReturnType(let method, let expected):
            return "Incorrect return type subbed for \(method), expected \(expected)"
        }
    }
}
