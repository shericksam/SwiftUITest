//
//  PokemonCoreDataExtension.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 09/07/23.
//

import Foundation
import CoreData

extension FullData: Identifiable {
    public var id: Int {
        self.num
    }
}

extension Pokemon: FragmentUpdatable {
    typealias Fragment = FullData

    func update(with fragment: Fragment) {
        self.backSprite = fragment.backSprite
        self.baseStatsTotal = Int16(fragment.baseStatsTotal)
        self.bulbapediaPage = fragment.bulbapediaPage
        self.color = fragment.color
        self.evolutionLevel = fragment.evolutionLevel
        self.forme = fragment.forme
        self.formeLetter = fragment.formeLetter
        self.height = Float(fragment.height)
        self.isEggObtainable = fragment.isEggObtainable
        self.key = fragment.key.rawValue
        self.legendary = fragment.legendary
        self.num = Int16(fragment.num)
        self.shinyBackSprite = fragment.shinyBackSprite
        self.shinySprite = fragment.shinySprite
        self.species = fragment.species
        self.sprite = fragment.sprite
        self.timestamp = Date()
        self.weight = Float(fragment.weight)
        updateBaseStats(with: fragment.baseStats)
//        self.evolutions = fragment.evolutions
//        self.evYields = fragment.evYields
//        self.gender = fragment.gender
//        self.preevolutions = fragment.preevolutions
//        self.types = fragment.types
//        fragment.evolutions
    }

    func updateBaseStats(with fragment: Fragment.BaseStat) {
        self.baseStats?.attack = Int16(fragment.attack)
        self.baseStats?.defense = Int16(fragment.defense)
        self.baseStats?.hp = Int16(fragment.hp)
        self.baseStats?.specialattack = Int16(fragment.specialattack)
        self.baseStats?.specialdefense = Int16(fragment.specialdefense)
        self.baseStats?.speed = Int16(fragment.speed)
    }

//    func updateEvolutions(with fragment: [Fragment.Evolution]) {
//        self.evolutions = fragment.map({ evolution in
//            evolution.
//        })
//    }
    func update(with model: PokemonModel, _ viewContext: NSManagedObjectContext) {
        self.backSprite = model.backSprite
        self.baseStatsTotal = Int16(model.baseStatsTotal)
        self.bulbapediaPage = model.bulbapediaPage
        self.color = model.color
        self.evolutionLevel = model.evolutionLevel
        self.forme = model.forme
        self.formeLetter = model.formeLetter
        self.height = Float(model.height)
        self.isEggObtainable = model.isEggObtainable
        self.key = model.key
        self.legendary = model.legendary
        self.num = Int16(model.num)
        self.shinyBackSprite = model.shinyBackSprite
        self.shinySprite = model.shinySprite
        self.species = model.species
        self.sprite = model.sprite
        self.timestamp = Date()
        self.weight = Float(model.weight)

        if let baseStatsUnwrapped = model.baseStats {
            self.baseStats = Stats(context: viewContext)
            baseStats?.update(with: baseStatsUnwrapped)
            try? viewContext.save()
        }

        if let evolutionsUnwrapped = model.evolutions {
            let pkmnSet = NSSet()
            for pkmn in evolutionsUnwrapped {
                let pkmnCoreObject = Pokemon(context: viewContext)
                pkmnCoreObject.update(with: pkmn, viewContext)
                pkmnSet.adding(pkmnCoreObject)
            }
            self.evolutions = pkmnSet
        }

        if let evYieldsUnwrapped = model.evYields {
            self.evYields = EvYields(context: viewContext)
            evYields?.update(with: evYieldsUnwrapped)
        }

        if let genderUnwrapped = model.gender {
            self.gender = Gender(context: viewContext)
            gender?.update(with: genderUnwrapped)
        }

        if let preevolutionsUnwrapped = model.evolutions {
            let pkmnSet = NSSet()
            for pkmn in preevolutionsUnwrapped {
                let pkmnCoreObject = Pokemon(context: viewContext)
                pkmnCoreObject.update(with: pkmn, viewContext)
                pkmnSet.adding(pkmnCoreObject)
            }
            self.preevolutions = pkmnSet
        }

        if let typesUnwrapped = model.types {
            let typesSet = NSSet()
            for type in typesUnwrapped {
                let typeCoreObject = PokemonType(context: viewContext)
                typeCoreObject.update(with: type, viewContext)
                typesSet.adding(typeCoreObject)
            }
            self.types = typesSet
        }
    }
}

extension Stats {
    func update(with model: StatsModel?) {
        guard let model else { return }
        self.attack = Int16(model.attack)
        self.defense = Int16(model.defense)
        self.hp = Int16(model.hp)
        self.specialattack = Int16(model.specialattack)
        self.specialdefense = Int16(model.specialdefense)
        self.speed = Int16(model.speed)
    }
}

extension EvYields {
    func update(with model: EvYieldsModel?) {
        guard let model else { return }
        self.attack = Int16(model.attack)
        self.defense = Int16(model.defense)
        self.hp = Int16(model.hp)
        self.specialattack = Int16(model.specialattack)
        self.specialdefense = Int16(model.specialdefense)
        self.speed = Int16(model.speed)
    }
}

extension Gender {
    func update(with model: GenderModel?) {
        guard let model else { return }
        self.female = model.female
        self.male = model.male
    }
}

extension PokemonType {
    func update(with model: PokemonTypeModel?, _ viewContext: NSManagedObjectContext) {
        guard let model else { return }
        self.name = model.name
        self.matchup = TypeMatchup(context: viewContext)
        matchup?.update(with: model.matchup, viewContext)
    }
}

extension TypeMatchup {
    func update(with model: TypeMatchupModel?, _ viewContext: NSManagedObjectContext) {
        guard let model else { return }
        self.attacking = TypeEffectiveness(context: viewContext)
        attacking?.update(with: model.attacking)
        self.defending = TypeEffectiveness(context: viewContext)
        defending?.update(with: model.defending)
    }
}

extension TypeEffectiveness {
    func update(with model: TypeEffectivenessModel?) {
        guard let model else { return }
        self.doubleEffectiveTypes = model.doubleEffectiveTypes as? NSArray
        self.doubleResistedTypes = model.doubleResistedTypes as? NSArray
        self.effectiveTypes = model.effectiveTypes as? NSArray
        self.effectlessTypes = model.effectlessTypes as? NSArray
        self.normalTypes = model.normalTypes as? NSArray
        self.resistedTypes = model.resistedTypes as? NSArray
    }
}
