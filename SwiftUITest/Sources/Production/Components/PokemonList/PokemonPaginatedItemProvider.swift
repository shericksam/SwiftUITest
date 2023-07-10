//
//  PokemonPaginatedItemProvider.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 07/07/23.
//

import SwiftUI
import CoreData

typealias PokemonFragmentItem = AllPokemonQuery.Data.GetAllPokemon

class PokemonPaginatedItemProvider: ObservableObject {
    @Published var showLoadingView: Bool = true
    @Published var errorMessage: String?
    @Published var items: [PokemonListingItem] = []
    private(set) var pageSize: Int = 20
    private(set) var startingIndex: Int = 0
    private(set) var triggerIndex: Int?
    private let constantSkipCAP: Int = 89
    let repository: PokemonRepository
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

    init(repository: PokemonRepository = Dependencies.pokemonRepository) {
        self.repository = repository
        Task {
            await getPokemon()
        }
    }

    func getPokemon(pagination: Pagination = PaginationImp(items: 0, pageSize: 20)) async {
        let pokemonResult = await self.repository.getPokemon(pagination)
        switch pokemonResult {
        case .success(let models):
            let items = models.map({ PokemonListingItem(index: $0.num, listing: $0) })
            self.updatePaginationInput(size: pageSize,
                                       triggerIndex: items[items.endIndex - 1].listing.num - 1,
                                       startingIndex: items.startIndex)
            self.isPaginating = false
            DispatchQueue.main.async {
                self.items.append(contentsOf: items)
            }
        case .failure(let error):
            self.errorMessage = error.localizedDescription
        }
    }

    func fetchNextPageIfNeeded(for item: PokemonListingItem) {
        paginationQueue.async { [weak self] in
            guard let self else { return }
            if let triggerIndex = self.triggerIndex, !self.isPaginating, item.index > triggerIndex {
                self.isPaginating.toggle()
                self.hasPaginated = true
                Task {
                    let pagination = PaginationImp(items: self.items.count, pageSize: 20, startingIndex: self.startingIndex, triggerIndex: self.triggerIndex)
                    await self.getPokemon(pagination: pagination)
                }
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
