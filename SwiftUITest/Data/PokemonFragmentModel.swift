//
//  PokemonFragmentModel.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 09/07/23.
//

import Foundation

extension AllPokemonQuery.Data {
    func convertToModel() -> [PokemonModel] {
        self.getAllPokemon.map { fragment in
            PokemonModel(with: fragment.fragments.lightDataFragmentWithoutNested)
        }
    }

    func convertToListing() -> [PokemonListingItem] {
        self.getAllPokemon.map { fragment in
            PokemonListingItem(index: fragment.num, listing: PokemonModel(with: fragment.fragments.lightDataFragmentWithoutNested))
        }
    }
}

extension GetPokemonQuery.Data {
    func convertToModel() -> PokemonModel {
        PokemonModel(with: self.getPokemon.fragments.fullData)
    }

}
