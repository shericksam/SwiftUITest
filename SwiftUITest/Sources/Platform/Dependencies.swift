//
//  Dependencies.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 06/07/23.
//

import Apollo
import Foundation

public class Dependencies {
    public private(set) static var serviceClient: ApolloServiceClientProvider = NoopApolloServiceClientProvider()
    public private(set) static var serverUrlProvider: ServerURLProvider = DefaultServerURL()

    public static func install(serverUrlProvider: ServerURLProvider,
                               serviceClient: ApolloServiceClientProvider) {
        self.serviceClient.cancelAllOperations()
        self.serviceClient = serviceClient
        self.serverUrlProvider = serverUrlProvider
    }
}

private class NoopApolloServiceClientProvider: ApolloServiceClientProvider {
    func cancelAllOperations() { }

    var client: ApolloClient {
        return ApolloClient(url: URL(string: "www.some.url")!)
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
}

private class DefaultServerURL: ServerURLProvider {
    func getServerUrl() -> URL {
        URL(string: "http://www.someURL.com")!
    }
}
