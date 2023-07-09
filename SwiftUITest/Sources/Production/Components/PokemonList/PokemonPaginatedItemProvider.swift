//
//  PokemonPaginatedItemProvider.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 07/07/23.
//

import SwiftUI

typealias PokemonFragmentItem = AllPokemonQuery.Data.GetAllPokemon

class PokemonPaginatedItemProvider: ObservableObject {
    @Published var showLoadingView: Bool = true
    private(set) var items: [PokemonListingItem] = []
    private(set) var pageSize: Int
    private(set) var startingIndex: Int
    private(set) var triggerIndex: Int?
    private let constantSkipCAP: Int = 89
    private var network: ApolloServiceClientProvider
    private var queryHolder: QueryHolder<AllPokemonQuery>
    private(set) var isPaginating = false {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.showLoadingView = self.isPaginating
            }
        }
    }
    private(set) var hasPaginated = false
    private var paginationQueue = DispatchQueue(label: "PokemonPaginatedItemProvider-\(UUID().uuidString)", qos: .userInitiated)

    init(items: [PokemonListingItem],
         size: Int,
         triggerIndex: Int? = nil,
         startingIndex: Int? = nil,
         network: ApolloServiceClientProvider = Dependencies.serviceClient) {
        self.items = items
        self.pageSize = size
        self.triggerIndex = triggerIndex
        self.startingIndex = startingIndex ?? items.count
        self.network = network
        self.showLoadingView = items.count < pageSize ? false : true
        self.queryHolder = QueryHolder(
            query: AllPokemonQuery(offset: constantSkipCAP)
        )
        self.paginate(with: queryHolder)
    }

    private func paginate(with queryHolder: QueryHolder<AllPokemonQuery>) {
        queryHolder.query.offset = constantSkipCAP + items.count
        queryHolder.query.take = pageSize
        queryHolder.query.execute(serviceClient: network) { [weak self] result in
            self?.paginationQueue.async {
                DispatchQueue.main.async {
                    guard let self else { return }
                    switch result {
                    case .success(let response):
                        let fragment = response.data
                        self.updatePaginationInput(size: fragment.pageSize,
                                                   triggerIndex: fragment.triggerIndex,
                                                   startingIndex: fragment.startingIndex)
                        self.isPaginating = false
                        let items = fragment.convertToListing()
                        self.items.append(contentsOf: items)
                    case .failure:
                        self.isPaginating = false
                    }
                }
            }
        }
    }

    func fetchNextPageIfNeeded(for item: PokemonListingItem) {
        paginationQueue.async { [weak self] in
            guard let self else { return }
            if let triggerIndex = self.triggerIndex, !self.isPaginating, item.index > triggerIndex {
                self.isPaginating.toggle()
                self.hasPaginated = true
                self.paginate(with: self.queryHolder)
            }
        }
    }

    private func updatePaginationInput(size: Int,
                                       triggerIndex: Int? = nil,
                                       startingIndex: Int? = nil) {
        self.pageSize = size
        self.triggerIndex = triggerIndex
        self.startingIndex = startingIndex ?? items.count
    }
}

struct PokemonListingItem: Identifiable, Hashable {
    let id = UUID().uuidString
    let index: Int
    let listing: PokemonModel

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: PokemonListingItem, rhs: PokemonListingItem) -> Bool {
        lhs.id == rhs.id
    }
}

extension AllPokemonQuery.Data {
    var items: [PokemonFragmentItem] {
        getAllPokemon.compactMap { $0 }
    }

    var pageSize: Int {
        getAllPokemon.count
    }

    var startingIndex: Int? {
        getAllPokemon.startIndex
    }

    var triggerIndex: Int? {
        getAllPokemon[getAllPokemon.endIndex - 1].num - 1
    }
}
