//
//  PokemonDataSource.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 08/07/23.
//

import Foundation

protocol PokemonDataSource {
    func getAll(_ pagination: Pagination?) async throws -> [PokemonModel]
    func getById(_ pokemonEnum: String) async throws -> PokemonModel?
    func delete(_ num: Int) async throws -> ()
    func create(pokemon: PokemonModel) async throws -> ()
    func createList(pokemon: [PokemonModel]) async throws -> ()
    func update(num: Int, pokemon: PokemonModel) async throws -> ()
}
