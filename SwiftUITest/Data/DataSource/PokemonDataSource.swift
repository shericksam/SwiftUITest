//
//  PokemonDataSource.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 08/07/23.
//

import Foundation

protocol PokemonDataSource {
    func getAll() async throws -> [PokemonModel]
    func getById(_ num: Int) async throws -> PokemonModel?
    func delete(_ num: Int) async throws -> ()
    func create(pokemon: PokemonModel) async throws -> ()
    func update(num: Int, pokemon: PokemonModel) async throws -> ()
}
