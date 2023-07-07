//
//  ComponentNetwork.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 06/07/23.
//

import Apollo
import Foundation

extension GraphQLQuery {

    @discardableResult
    func execute(serviceClient: ApolloServiceClientProvider = Dependencies.serviceClient,
                 queue: DispatchQueue = .main,
                 completion: @escaping (Swift.Result<GraphQLCachingQueryResult<Self.Data>, GraphQLCachingQueryError>) -> Void) -> ApolloCancellable? {
        let cancellable = serviceClient.fetch(query: self, queue: queue) { queryResult in
            var response: Swift.Result<GraphQLCachingQueryResult<Self.Data>, GraphQLCachingQueryError>
            switch queryResult {
            case .success(let result):
                if let resultData = result.data,
                   let data = try? Self.Data(resultData) {
                    let queryResult = GraphQLCachingQueryResult(data: data, extensions: result.extensions)
                    response = .success(queryResult)
                } else {
                    if let serviceErrors = result.errors, serviceErrors.hasElements {
                        var currentTraceId: String?
                        if let extensions = result.extensions, let trace = extensions["trace"] as? [String: String], let traceId = trace["Trace-ID"] {
                            currentTraceId = traceId
                        }
                        response = .failure(.serviceError(errors: serviceErrors, traceId: currentTraceId))
                    } else {
                        response = .failure(.unknownError())
                    }
                }
            case .failure(let error):
                let newError = error as? URLSessionClient.URLSessionClientError

                switch newError {
                case .networkError(let data, let networkResponse, let underlyingError):
                    response = .failure(.networkError(data: data, response: networkResponse, underlyingError: underlyingError))
                default:
                    response = .failure(.unknownError(underlyingError: error))
                }
            }
            completion(response)
        }
        return cancellable
    }
}

extension GraphQLMutation {

    @discardableResult
    func execute(serviceClient: ApolloServiceClientProvider = Dependencies.serviceClient,
                 completion: ((Swift.Result<GraphQLCachingQueryResult<Self.Data>, GraphQLCachingQueryError>) -> Void)? = nil) -> ApolloCancellable? {
        let cancellable = serviceClient.perform(mutation: self) { queryResult in
            var response: Swift.Result<GraphQLCachingQueryResult<Self.Data>, GraphQLCachingQueryError>
            switch queryResult {
            case .success(let result):
                if let resultData = result.data,
                   let data = try? Self.Data(resultData) {
                    let queryResult = GraphQLCachingQueryResult(data: data, extensions: result.extensions)
                    response = .success(queryResult)
                } else {
                    response = .failure(.unknownError())
                }
            case .failure(let error):
                let newError = error as? URLSessionClient.URLSessionClientError
                switch newError {
                case .networkError(let data, let networkResponse, let underlyingError):
                    response = .failure(.networkError(data: data, response: networkResponse, underlyingError: underlyingError))
                default:
                    response = .failure(.unknownError(underlyingError: error))
                }
            }
            completion?(response)
        }
        return cancellable
    }
}

