//
//  PokemonRepositoryImpl.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 09/07/23.
//

import Foundation

struct PokemonRepositoryImpl: PokemonRepository {

    var graphQLDataSource: PokemonDataSource
    var coreDataSource: PokemonDataSource

    func getPokemon(pokemonEnum: String) async  -> Result<PokemonModel?, DataSourceGenericError> {
        do {
            let _todo =  try await coreDataSource.getById(pokemonEnum)
            return .success(_todo)
        } catch {
            return .failure(.FetchError)
        }

    }

    func deletePokemon(_ num: Int) async ->  Result<Bool, DataSourceGenericError>  {
        do {
            try await coreDataSource.delete(num)
            return .success(true)
        } catch {
            return .failure(.DeleteError)
        }

    }

    func createPokemon(_ pokemon: PokemonModel) async ->  Result<Bool, DataSourceGenericError>   {
        do {
            try await coreDataSource.create(pokemon: pokemon)
            return .success(true)
        } catch {
            return .failure(.CreateError)
        }

    }

    func updatePokemon(_ pokemon: PokemonModel) async ->  Result<Bool, DataSourceGenericError>   {
        do {
            try await coreDataSource.update(num: pokemon.num, pokemon: pokemon)
            return .success(true)
        } catch {
            return .failure(.UpdateError)
        }

    }

    func getPokemon(_ pagination: Pagination?) async -> Result<[PokemonModel], DataSourceGenericError> {
        do {
            if NetworkChecker.isConnected() {
                let models = try await graphQLDataSource.getAll(pagination)
                try await coreDataSource.createList(pokemon: models)
            }
            let _todos =  try await coreDataSource.getAll(pagination)
            return .success(_todos)
        } catch {
            return .failure(.FetchError)
        }
    }
}
