//
//  ExplorerApolloNetworkStack.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 06/07/23.
//
import Apollo
import ApolloUtils
import Foundation

class ExplorerApolloNetworkStack: InterceptorProvider {
    private let urlSessionClient: URLSessionClient
    private let store: ApolloStore

    init(store: ApolloStore,
         urlSessionClient: URLSessionClient) {
        self.store = store
        self.urlSessionClient = urlSessionClient
    }

    deinit {
        self.urlSessionClient.invalidate()
    }

    func interceptors<Operation>(for operation: Operation) -> [ApolloInterceptor] where Operation: GraphQLOperation {
        [
//            AuthenticationInterceptor(),
//            MaxRetryInterceptor(),
//            CacheReadInterceptor(store: store),
//            ResponseCodeInterceptor(),
//            JSONResponseParsingInterceptor(cacheKeyForObject: store.cacheKeyForObject),
//            AutomaticPersistedQueryInterceptor(),
//            CacheWriteInterceptor(store: store)
            MaxRetryInterceptor(),
            CacheReadInterceptor(store: store),
            NetworkFetchInterceptor(client: urlSessionClient),
            ResponseCodeInterceptor(),
            JSONResponseParsingInterceptor(),
            AutomaticPersistedQueryInterceptor(),
            CacheWriteInterceptor(store: store)
        ]
    }
}

