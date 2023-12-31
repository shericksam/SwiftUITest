//
//  PokemonCoreDataSourceImpl.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 08/07/23.
//

import Foundation
import CoreData

struct PokemonCoreDataSourceImpl: PokemonDataSource {
    var container: NSPersistentContainer

    init(container: NSPersistentContainer){
        self.container = container
    }

    func getAll(_ pagination: Pagination?) throws -> [PokemonModel] {
        let request = Pokemon.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Pokemon.num, ascending: true),
                                   NSSortDescriptor(keyPath: \Pokemon.key, ascending: true)]
        if let pagination {
            request.fetchLimit = pagination.pageSize
            request.fetchOffset = pagination.items
        }
        return try container.viewContext.fetch(request).map({ pokemonCoreDataEntity in
            PokemonModel(with: pokemonCoreDataEntity)
        })
    }

    func getById(_ pokemonEnum: String)  throws  -> PokemonModel? {
        let pokemonCoreDataEntity = try getEntityById(pokemonEnum)!
        return PokemonModel(with: pokemonCoreDataEntity)

    }

    func delete(_ num: Int) throws -> () {
        let todoCoreDataEntity = try getEntityByNum(num)!
        let context = container.viewContext;
        context.delete(todoCoreDataEntity)
        do{
            try context.save()
        }catch{
            context.rollback()
            fatalError("Error: \(error.localizedDescription)")
        }

    }

    func create(pokemon: PokemonModel) throws -> () {
        do {
            let todoCoreDataEntity = Pokemon(context: container.viewContext)
            todoCoreDataEntity.update(with: pokemon, container.viewContext)
            addEvolution(model: pokemon)
            try todoCoreDataEntity.validateForInsert()
            try todoCoreDataEntity.validateForUpdate()
            saveContext()
        } catch  {
            print(error)
        }
    }

    func createList(pokemon: [PokemonModel]) async throws {
        let context = container.viewContext
        return await withCheckedContinuation { continuation in
            for data in pokemon {
                do {
                    let pkmnCoreDataEntity = Pokemon(context: context)
                    pkmnCoreDataEntity.update(with: data, context)

                    try pkmnCoreDataEntity.validateForInsert()
                    try pkmnCoreDataEntity.validateForUpdate()
                } catch {
                    print("pkmnCoreDataEntity-->", error.localizedDescription)
                }
            }
            do {
                try context.save()
                continuation.resume()
            } catch {
                continuation.resume(returning: ())
            }
        }
    }

    func update(num: Int, pokemon: PokemonModel) throws -> () {
        let todoCoreDataEntity = try getEntityByNum(num)!
        todoCoreDataEntity.update(with: pokemon, container.viewContext)
        saveContext()
    }

    private func getEntityById(_ pokemonEnum: String) throws  -> Pokemon? {
        let request = Pokemon.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "key = %@", pokemonEnum)
        let context =  container.viewContext
        let pkmnCoreDataEntity = try context.fetch(request).first
        return pkmnCoreDataEntity

    }

    private func getEntityByNum(_ num: Int)  throws  -> Pokemon? {
        let request = Pokemon.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "num = %@", num.description)
        let context =  container.viewContext
        let pkmnCoreDataEntity = try context.fetch(request).first
        return pkmnCoreDataEntity

    }

    private func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do{
                try context.save()
            }catch{
                print("error", error.localizedDescription)
//                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }

    private func addEvolution(model: PokemonModel) {
        if let evolutionsUnwrapped = model.evolutions {
            for pkmn in evolutionsUnwrapped {
                do {
                    guard let key1 = model.key, let key2 = pkmn.key else { return }
                    let pkmn1 = try getEntityById(key1)
                    let pkmn2 = try getEntityById(key2)


                    let evolution = PokemonEvolution(context: container.viewContext)
                    evolution.pokemon = pkmn1
                    evolution.evolution = pkmn2

                    pkmn1?.evolutions = pkmn1?.evolutions ?? NSSet()
                    pkmn1?.addToEvolutions(evolution)

                    try evolution.validateForInsert()
                    try evolution.validateForUpdate()
                } catch  {
                    print("model.evolutions erro", error.localizedDescription)
                }
            }
        }
        if let preevolutionsUnwrapped = model.preevolutions {
            for pkmn in preevolutionsUnwrapped {
                do {
                    guard let key1 = model.key, let key2 = pkmn.key else { return }
                    let pkmn1 = try getEntityById(key1)
                    let pkmn2 = try getEntityById(key2)


                    let evolution = PokemonEvolution(context: container.viewContext)
                    evolution.pokemon = pkmn1
                    evolution.evolution = pkmn2

                    pkmn1?.preevolutions = pkmn1?.preevolutions ?? NSSet()
                    pkmn1?.addToPreevolutions(evolution)

                    try evolution.validateForInsert()
                    try evolution.validateForUpdate()
                } catch  {
                    print("model.preevolutions erro", error.localizedDescription)
                }
            }
        }
    }
}
