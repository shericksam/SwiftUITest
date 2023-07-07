//
//  ExplorerApolloServiceClientProvider.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 06/07/23.
//

import Apollo
import Foundation

class ExplorerApolloServiceClientProvider: ApolloServiceClientProvider {

    func cancelAllOperations() { }

    static let shared = ExplorerApolloServiceClientProvider()

    var client: ApolloClient {
        let url = ActiveServerUrl.getGraphQLServiceUrl()
        if let apolloClient = cachedApolloClient,
           url.host == cachedApolloClientURL?.host {
            return apolloClient
        }

        return createAndCacheApolloClient(url: url)
    }

    private var cachedApolloClient: ApolloClient?
    private var cachedApolloClientURL: URL?

    init() { }

    func fetch<Query>(query: Query,
                      queue: DispatchQueue = .main,
                      resultHandler: ((Swift.Result<GraphQLResult<Query.Data>, Error>) -> Void)?) -> ApolloCancellable? where Query: GraphQLQuery {
        return ApolloCancellable(apolloCancellable: client.fetch(query: query,
                                                                 cachePolicy: .fetchIgnoringCacheCompletely,
                                                                 resultHandler: resultHandler))
    }

    func perform<Mutation>(mutation: Mutation,
                           resultHandler: ((Swift.Result<GraphQLResult<Mutation.Data>, Error>) -> Void)?) -> ApolloCancellable? where Mutation: GraphQLMutation {
        return ApolloCancellable(apolloCancellable: client.perform(mutation: mutation,
                                                                   resultHandler: resultHandler))
    }

    private func createAndCacheApolloClient(url: URL) -> ApolloClient {
        let store = ApolloStore()
        let urlSessionClient = InsecureApolloURLSessionClient()
        let interceptorProvider = ExplorerApolloNetworkStack(store: store,
                                                             urlSessionClient: urlSessionClient)
        let network = RequestChainNetworkTransport(interceptorProvider: interceptorProvider, endpointURL: url)
        let apolloClient = ApolloClient(networkTransport: network,
                                        store: store)
        cachedApolloClientURL = url
        cachedApolloClient = apolloClient
        return apolloClient
    }
}
