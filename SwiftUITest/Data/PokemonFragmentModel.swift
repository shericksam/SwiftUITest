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
}
