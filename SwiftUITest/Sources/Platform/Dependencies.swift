//
//  Dependencies.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 06/07/23.
//

import Apollo
import Foundation

public class Dependencies {
    public private(set) static var serviceClient: ApolloServiceClientProvider = BaseApolloServiceClientProvider.shared
    public private(set) static var serverUrlProvider: ServerURLProvider = DefaultServerURL()
    private(set) static var pokemonCoreDataSource = PokemonCoreDataSourceImpl(container: PersistenceController.shared.container)
    private(set) static var pokemonGraphQLDataSource = PokemonGraphQLDataSourceImp(network: serviceClient)
    private(set) static var pokemonRepository = PokemonRepositoryImpl(graphQLDataSource: pokemonGraphQLDataSource, coreDataSource: pokemonCoreDataSource)
    private(set) static var pokemonListViewModel = PokemonListViewModel()

    public static func install(serverUrlProvider: ServerURLProvider,
                               serviceClient: ApolloServiceClientProvider) {
        self.serviceClient.cancelAllOperations()
        self.serviceClient = serviceClient
        self.serverUrlProvider = serverUrlProvider
    }
}

private class BaseApolloServiceClientProvider: ApolloServiceClientProvider {

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

    init() {
        ActiveServerUrl.set()
    }

    func cancelAllOperations() { }

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

private class DefaultServerURL: ServerURLProvider {
    func getServerUrl() -> URL {
        URL(string: "http://www.someURL.com")!
    }
}
