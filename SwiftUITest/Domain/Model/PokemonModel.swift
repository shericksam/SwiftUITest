//
//  PokemonModel.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 09/07/23.
//

import Foundation

struct PokemonModel: Identifiable {
    let id: UUID = UUID()
    var backSprite: String?
    var baseStatsTotal: Int = 0
    var bulbapediaPage: String?
    var color: String?
    var evolutionLevel: String?
    var forme: String?
    var formeLetter: String?
    var height: Float = 0
    var isEggObtainable: Bool = false
    var key: String?
    var legendary: Bool = false
    var num: Int
    var shinyBackSprite: String?
    var shinySprite: String?
    var species: String?
    var sprite: String?
    var timestamp: Date?
    var weight: Float = 0
    var baseStats: StatsModel?
    var evolutions: [PokemonModel]?
    var evYields: EvYieldsModel?
    var gender: GenderModel?
    var preevolutions: [PokemonModel]?
    var types: [PokemonTypeModel]?

    init(
        backSprite: String?,
        baseStatsTotal: Int = 0,
        bulbapediaPage: String?,
        color: String?,
        evolutionLevel: String?,
        forme: String?,
        formeLetter: String?,
        height: Float = 0,
        isEggObtainable: Bool = false,
        key: String?,
        legendary: Bool = false,
        num: Int,
        shinyBackSprite: String?,
        shinySprite: String?,
        species: String?,
        sprite: String?,
        timestamp: Date?,
        weight: Float = 0,
        baseStats: StatsModel?,
        evolutions: [PokemonModel]?,
        evYields: EvYieldsModel?,
        gender: GenderModel?,
        preevolutions: [PokemonModel]?,
        types: [PokemonTypeModel]?) {
            self.backSprite = backSprite
            self.baseStatsTotal = baseStatsTotal
            self.bulbapediaPage = bulbapediaPage
            self.color = color
            self.evolutionLevel = evolutionLevel
            self.forme = forme
            self.formeLetter = formeLetter
            self.height = height
            self.isEggObtainable = isEggObtainable
            self.key = key
            self.legendary = legendary
            self.num = num
            self.shinyBackSprite = shinyBackSprite
            self.shinySprite = shinySprite
            self.species = species
            self.sprite = sprite
            self.timestamp = timestamp
            self.weight = weight
            self.baseStats = baseStats
            self.evolutions = evolutions
            self.evYields = evYields
            self.gender = gender
            self.preevolutions = preevolutions
            self.types = types
    }
    
    init(with coreDataModel: Pokemon) {
        self.backSprite = coreDataModel.backSprite
        self.baseStatsTotal = Int(coreDataModel.baseStatsTotal)
        self.bulbapediaPage = coreDataModel.bulbapediaPage
        self.color = coreDataModel.color
        self.evolutionLevel = coreDataModel.evolutionLevel
        self.forme = coreDataModel.forme
        self.formeLetter = coreDataModel.formeLetter
        self.height = coreDataModel.height
        self.isEggObtainable = coreDataModel.isEggObtainable
        self.key = coreDataModel.key
        self.legendary = coreDataModel.legendary
        self.num = Int(coreDataModel.num)
        self.shinyBackSprite = coreDataModel.shinyBackSprite
        self.shinySprite = coreDataModel.shinySprite
        self.species = coreDataModel.species
        self.sprite = coreDataModel.sprite
        self.timestamp = coreDataModel.timestamp
        self.weight = coreDataModel.weight
        self.baseStats = StatsModel(with: coreDataModel.baseStats)
        self.evolutions = coreDataModel.evolutions?.allObjects
            .map({ $0 as! Pokemon })
            .map({ PokemonModel(with: $0) })
        self.evYields = EvYieldsModel(with: coreDataModel.evYields)
        self.gender = GenderModel(with: coreDataModel.gender)
        self.preevolutions = coreDataModel.preevolutions?.allObjects
            .map({ $0 as! Pokemon })
            .map({ PokemonModel(with: $0) })
        self.types = coreDataModel.types?.allObjects
            .map({ $0 as! PokemonType })
            .map({ PokemonTypeModel(with: $0) })
            .compactMap { $0 }
    }

    init(with fragment: LightDataFragmentWithoutNested) {
        self.key = fragment.key.rawValue
        self.num = fragment.num
        self.color = fragment.color
        self.species = fragment.species
        self.sprite = fragment.sprite
        self.types = fragment.types.map({ ligthtype in
            PokemonTypeModel(name: ligthtype.name)
        })
    }

    init(with fragment: FullData) {
        self.backSprite = fragment.backSprite
        self.baseStatsTotal = Int(fragment.baseStatsTotal)
        self.bulbapediaPage = fragment.bulbapediaPage
        self.color = fragment.color
        self.evolutionLevel = fragment.evolutionLevel
        self.forme = fragment.forme
        self.formeLetter = fragment.formeLetter
        self.height = Float(fragment.height)
        self.isEggObtainable = fragment.isEggObtainable
        self.key = fragment.key.rawValue
        self.legendary = fragment.legendary
        self.num = Int(fragment.num)
        self.shinyBackSprite = fragment.shinyBackSprite
        self.shinySprite = fragment.shinySprite
        self.species = fragment.species
        self.sprite = fragment.sprite
        self.timestamp = Date()
        self.weight = Float(fragment.weight)
        self.baseStats = StatsModel(with: fragment.baseStats.fragments.statsFragment)
        self.evolutions = fragment.evolutions?
            .map({ $0.fragments.fullDataFragment })
            .map({ PokemonModel(with: $0) })
        self.evYields = EvYieldsModel(with: fragment.evYields.fragments.evYieldsFragment)
        self.gender = GenderModel(with: fragment.gender.fragments.genderFragment)
        self.preevolutions = fragment.preevolutions?
            .map({ $0.fragments.fullDataFragment })
            .map({ PokemonModel(with: $0) })
        self.types = fragment.types
            .map({ PokemonTypeModel(with: $0.fragments.pokemonTypeFragment) })
            .compactMap { $0 }
    }

    init(with fragment: FullDataFragment) {
        self.backSprite = fragment.backSprite
        self.baseStatsTotal = Int(fragment.baseStatsTotal)
        self.bulbapediaPage = fragment.bulbapediaPage
        self.color = fragment.color
        self.evolutionLevel = fragment.evolutionLevel
        self.forme = fragment.forme
        self.formeLetter = fragment.formeLetter
        self.height = Float(fragment.height)
        self.isEggObtainable = fragment.isEggObtainable
        self.key = fragment.key.rawValue
        self.legendary = fragment.legendary
        self.num = Int(fragment.num)
        self.shinyBackSprite = fragment.shinyBackSprite
        self.shinySprite = fragment.shinySprite
        self.species = fragment.species
        self.sprite = fragment.sprite
        self.timestamp = Date()
        self.weight = Float(fragment.weight)
        self.types = fragment.types
            .map({ PokemonTypeModel(with: $0.fragments.pokemonTypeFragment) })
            .compactMap { $0 }
    }
}
