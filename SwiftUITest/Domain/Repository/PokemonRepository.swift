//
//  PokemonRepository.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 09/07/23.
//

import Foundation

protocol PokemonRepository {
    func getPokemon(_ pagination: (any Pagination)?) async -> Result<[PokemonModel], DataSourceGenericError>
    func getPokemon(pokemonEnum: String) async -> Result<PokemonModel? , DataSourceGenericError>
    func deletePokemon(_ num: Int) async -> Result<Bool, DataSourceGenericError>
    func createPokemon(_ pokemon: PokemonModel) async -> Result<Bool, DataSourceGenericError>
    func updatePokemon(_ pokemon: PokemonModel) async -> Result<Bool, DataSourceGenericError>
}
