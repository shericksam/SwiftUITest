//
//  PokemonAPIDataSourceImp.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 09/07/23.
//

import Foundation

struct PokemonAPIDataSourceImp: PokemonDataSource {
    private var network: ApolloServiceClientProvider
    private var queryHolder: QueryHolder<AllPokemonQuery>
    private let constantSkipCAP: Int = 89
    private var paginationQueue = DispatchQueue(label: "PokemonPaginatedItemProvider-\(UUID().uuidString)", qos: .userInitiated)
    private(set) var isPaginating = false

    init(network: ApolloServiceClientProvider = Dependencies.serviceClient){
        self.network = network
        self.queryHolder = QueryHolder(
            query: AllPokemonQuery(offset: constantSkipCAP)
        )
    }

    private func fetchDataFromAPI(pagination: (any Pagination)?) async -> [PokemonModel] {
        return await withCheckedContinuation { continuation in
            if let pagination {
                queryHolder.query.offset = constantSkipCAP + pagination.items.count
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


//    private func paginate(pagination: any Pagination) {
//        Task {
//            await fetchDataFromAPI(pagination: pagination)
//        }
//        queryHolder.query.execute(serviceClient: network) { [weak self] result in
//            self?.paginationQueue.async {
//                DispatchQueue.main.async {
//                    guard let self else { return }
//                    switch result {
//                    case .success(let response):
//                        let fragment = response.data
////                        self.updatePaginationInput(size: fragment.pageSize,
////                                                   triggerIndex: fragment.triggerIndex,
////                                                   startingIndex: fragment.startingIndex)
////                        self.isPaginating = false
//                        let items = fragment.convertToListing()
////                        self.saveDataFromAPI(items.map({ $0.listing }))
//
////                        self.items.append(contentsOf: items)
//                    case .failure: break
////                        self.isPaginating = false
//                    }
//                }
//            }
//        }
//    }

//    func fetchNextPageIfNeeded(for item: PokemonListingItem) {
//        paginationQueue.async { [weak self] in
//            guard let self else { return }
//            if let triggerIndex = self.triggerIndex, !self.isPaginating, item.index > triggerIndex {
//                self.isPaginating.toggle()
//                self.hasPaginated = true
//                self.paginate(with: self.queryHolder)
//            }
//        }
//    }

//    private func updatePaginationInput(size: Int,
//                                       triggerIndex: Int? = nil,
//                                       startingIndex: Int? = nil) {
//        self.pageSize = size
//        self.triggerIndex = triggerIndex
//        self.startingIndex = startingIndex ?? items.count
//    }

    func getAll(_ pagination: (any Pagination)?) async throws -> [PokemonModel] {
        await fetchDataFromAPI(pagination: pagination)
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
}
