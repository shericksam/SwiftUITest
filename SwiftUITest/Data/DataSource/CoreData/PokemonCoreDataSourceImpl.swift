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
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Pokemon.num, ascending: true)]
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
            if try getEntityByNum(pokemon.num) == nil {
                let todoCoreDataEntity = Pokemon(context: container.viewContext)
                todoCoreDataEntity.update(with: pokemon, container.viewContext)
                saveContext()
            }
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
                } catch { }
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
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }

}
