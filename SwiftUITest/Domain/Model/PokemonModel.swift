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
        self.species = fragment.species
        self.sprite = fragment.sprite
        self.types = fragment.types.map({ ligthtype in
            PokemonTypeModel(name: ligthtype.name)
        })
    }
}
