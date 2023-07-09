////
////  PokemonFragmentExtension.swift
////  SwiftUITest
////
////  Created by Erick Samuel Guerrero Arreola on 08/07/23.
////
//
//import Foundation
//
//extension FullData: Identifiable {
//    public var id: Int {
//        self.num
//    }
//}
//
//extension Pokemon: FragmentUpdatable {
//    typealias Fragment = FullData
//
//    func update(with fragment: Fragment) {
//        self.backSprite = fragment.backSprite
//        self.baseStatsTotal = Int16(fragment.baseStatsTotal)
//        self.bulbapediaPage = fragment.bulbapediaPage
//        self.color = fragment.color
//        self.evolutionLevel = fragment.evolutionLevel
//        self.forme = fragment.forme
//        self.formeLetter = fragment.formeLetter
//        self.height = Float(fragment.height)
//        self.isEggObtainable = fragment.isEggObtainable
//        self.key = fragment.key.rawValue
//        self.legendary = fragment.legendary
//        self.num = Int16(fragment.num)
//        self.shinyBackSprite = fragment.shinyBackSprite
//        self.shinySprite = fragment.shinySprite
//        self.species = fragment.species
//        self.sprite = fragment.sprite
//        self.timestamp = Date()
//        self.weight = Float(fragment.weight)
//        updateBaseStats(with: fragment.baseStats)
////        self.evolutions = fragment.evolutions
////        self.evYields = fragment.evYields
////        self.gender = fragment.gender
////        self.preevolutions = fragment.preevolutions
////        self.types = fragment.types
////        fragment.evolutions
//    }
//
//    func updateBaseStats(with fragment: Fragment.BaseStat) {
//        self.baseStats?.attack = Int16(fragment.attack)
//        self.baseStats?.defense = Int16(fragment.defense)
//        self.baseStats?.hp = Int16(fragment.hp)
//        self.baseStats?.specialattack = Int16(fragment.specialattack)
//        self.baseStats?.specialdefense = Int16(fragment.specialdefense)
//        self.baseStats?.speed = Int16(fragment.speed)
//    }
//
////    func updateEvolutions(with fragment: [Fragment.Evolution]) {
////        self.evolutions = fragment.map({ evolution in
////            evolution.
////        })
////    }
//}
//
////extension FullData.Evolution {
////    func asCoreDataItems() -> [Pokemon] {
////        Pokemon.object(in: , withFragment: self)
////    }
////}
