//
//  Result.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 06/07/23.
//

import Apollo
import Foundation

public enum GraphQLCachingQueryError: LocalizedError, Equatable {
    case networkError(data: Data? = nil,
                      response: HTTPURLResponse? = nil,
                      underlyingError: Error? = nil)
    case serviceError(errors: [GraphQLError],
                      traceId: String? = nil)
    case unknownError(underlyingError: Error? = nil)

    public var errorDescription: String? {
        switch self {
        case let .networkError(_, _, error):
            return error?.localizedDescription
        case let .serviceError(errors, _):
            return errors.compactMap {
                "\($0.extensions?["code"] ?? "unknown code") - \($0.message ?? "unknown message")"
            }.joined(separator: " | ")
        case let .unknownError(error):
            return error?.localizedDescription
        }
    }

    public static func == (lhs: GraphQLCachingQueryError, rhs: GraphQLCachingQueryError) -> Bool {
        switch (lhs, rhs) {
        case (.unknownError, .unknownError), (.networkError, .networkError), (.serviceError, .serviceError):
            return true
        default:
            return false
        }
    }
}

public struct GraphQLCachingQueryResult<T> {
    let data: T
    let extensions: [String: Any]?
}

