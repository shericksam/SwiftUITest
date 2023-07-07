//
//  ApolloServiceClientProvider.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 06/07/23.
//

import Apollo
import UIKit

public protocol ApolloServiceClientProvider {
    func cancelAllOperations()
    func fetch<Query>(query: Query,
                      queue: DispatchQueue,
                      resultHandler: ((Swift.Result<Apollo.GraphQLResult<Query.Data>, Error>) -> Void)?) -> ApolloCancellable? where Query: GraphQLQuery
    func perform<Mutation>(mutation: Mutation,
                           resultHandler: ((Swift.Result<Apollo.GraphQLResult<Mutation.Data>, Error>) -> Void)?) -> ApolloCancellable? where Mutation: GraphQLMutation
}

public extension ApolloServiceClientProvider {
    func fetch<Query>(query: Query,
                      queue: DispatchQueue) async -> Swift.Result<Apollo.GraphQLResult<Query.Data>, Error> where Query: GraphQLQuery {
        return await withCheckedContinuation { continuation in
            let cancellable = fetch(query: query, queue: queue) { result in
                switch result {
                case .success(let graphQLResult):
                    continuation.resume(returning: Swift.Result.success(graphQLResult))
                case .failure(let error):
                    continuation.resume(returning: Swift.Result.failure(error))
                }
            }
        }
    }

    func perform<Mutation>(mutation: Mutation) async -> Swift.Result<Apollo.GraphQLResult<Mutation.Data>, Error> where Mutation: GraphQLMutation {
        return await withCheckedContinuation { continuation in
            let cancellable = perform(mutation: mutation) { result in
                switch result {
                case .success(let graphQLResult):
                    continuation.resume(returning: Swift.Result.success(graphQLResult))
                case .failure(let error):
                    continuation.resume(returning: Swift.Result.failure(error))
                }
            }
        }
    }
}

