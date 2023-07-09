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

    func getAll() throws -> [PokemonModel] {
        let request = Pokemon.fetchRequest()
        return try container.viewContext.fetch(request).map({ pokemonCoreDataEntity in
            PokemonModel(with: pokemonCoreDataEntity)
        })

    }

    func getById(_ num: Int)  throws  -> PokemonModel? {
        let pokemonCoreDataEntity = try getEntityById(num)!
        return PokemonModel(with: pokemonCoreDataEntity)

    }

    func delete(_ num: Int) throws -> () {
        let todoCoreDataEntity = try getEntityById(num)!
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
            if try getEntityById(pokemon.num) == nil {
                let todoCoreDataEntity = Pokemon(context: container.viewContext)
                todoCoreDataEntity.update(with: pokemon, container.viewContext)
                saveContext()
            }
        } catch  {
            print(error)
        }
    }

    func update(num: Int, pokemon: PokemonModel) throws -> () {
        let todoCoreDataEntity = try getEntityById(num)!
        todoCoreDataEntity.update(with: pokemon, container.viewContext)
        saveContext()
    }

    private func getEntityById(_ num: Int)  throws  -> Pokemon? {
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
