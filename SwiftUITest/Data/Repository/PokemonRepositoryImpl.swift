//
//  PokemonRepositoryImpl.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 09/07/23.
//

import Foundation

struct PokemonRepositoryImpl: PokemonRepository {

    var dataSource: PokemonDataSource

    func getPokemon(num: Int) async  -> Result<PokemonModel?, DataSourceGenericError> {
        do{
            let _todo =  try await dataSource.getById(num)
            return .success(_todo)
        }catch{
            return .failure(.FetchError)
        }

    }

    func deletePokemon(_ num: Int) async ->  Result<Bool, DataSourceGenericError>  {
        do{
            try await dataSource.delete(num)
            return .success(true)
        }catch{
            return .failure(.DeleteError)
        }

    }

    func createPokemon(_ pokemon: PokemonModel) async ->  Result<Bool, DataSourceGenericError>   {
        do{
            try await dataSource.create(pokemon: pokemon)
            return .success(true)
        }catch{
            return .failure(.CreateError)
        }

    }

    func updatePokemon(_ pokemon: PokemonModel) async ->  Result<Bool, DataSourceGenericError>   {
        do{
            try await dataSource.update(num: pokemon.num, pokemon: pokemon)
            return .success(true)
        }catch{
            return .failure(.UpdateError)
        }

    }

    func getPokemon() async -> Result<[PokemonModel], DataSourceGenericError> {
        do{
            let _todos =  try await dataSource.getAll()
            return .success(_todos)
        }catch{
            return .failure(.FetchError)
        }
    }
}