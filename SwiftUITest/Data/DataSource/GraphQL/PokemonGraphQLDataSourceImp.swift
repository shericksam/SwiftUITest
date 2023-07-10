//
//  PokemonGraphQLDataSourceImp.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 09/07/23.
//

import Foundation

struct PokemonGraphQLDataSourceImp: PokemonDataSource {
    private var network: ApolloServiceClientProvider
    private var queryHolder: QueryHolder<AllPokemonQuery>
    private let constantSkipCAP: Int = 89
    private var paginationQueue = DispatchQueue(label: "PokemonPaginatedItemProvider-\(UUID().uuidString)", qos: .userInitiated)

    init(network: ApolloServiceClientProvider = Dependencies.serviceClient){
        self.network = network
        self.queryHolder = QueryHolder(
            query: AllPokemonQuery(offset: constantSkipCAP)
        )
    }

    private func fetch(pagination: Pagination?) async -> [PokemonModel] {
        return await withCheckedContinuation { continuation in
            if let pagination {
                queryHolder.query.offset = constantSkipCAP + pagination.items
                queryHolder.query.take = pagination.pageSize
            }
            queryHolder.query.execute(serviceClient: network) { result in
                self.paginationQueue.async {
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let response):
                            let fragment = response.data
                            let items = fragment.convertToModel()
                            continuation.resume(returning: items)
                        case .failure:
                            continuation.resume(returning: [])
                        }
                    }
                }
            }
        }
    }

    func getAll(_ pagination: Pagination?) async throws -> [PokemonModel] {
        await fetch(pagination: pagination)
    }

    func getById(_ pokemonEnum: String) async throws -> PokemonModel? {
        let queryHolderGetPokemon = QueryHolder(query: GetPokemonQuery(pokemon: PokemonEnum(rawValue: pokemonEnum) ?? .bulbasaur))
        return await withCheckedContinuation { continuation in
            queryHolderGetPokemon.query.execute(serviceClient: network) { result in
                self.paginationQueue.async {
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let response):
                            let fragment = response.data
                            let item = fragment.convertToModel()
                            continuation.resume(returning: item)
                        case .failure:
                            continuation.resume(returning: nil)
                        }
                    }
                }
            }
        }
    }

    func delete(_ num: Int) async throws { }

    func create(pokemon: PokemonModel) async throws { }

    func update(num: Int, pokemon: PokemonModel) async throws { }

    func createList(pokemon: [PokemonModel]) async throws { }
}
