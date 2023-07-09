//
//  EvYieldsModel.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 09/07/23.
//

import Foundation

struct EvYieldsModel {
    var attack: Int
    var defense: Int
    var hp: Int
    var specialattack: Int
    var specialdefense: Int
    var speed: Int

    init?(with coreDataModel: EvYields?) {
        guard let coreDataModel else { return nil }
        self.attack = Int(coreDataModel.attack)
        self.defense = Int(coreDataModel.defense)
        self.hp = Int(coreDataModel.hp)
        self.specialattack = Int(coreDataModel.specialattack)
        self.specialdefense = Int(coreDataModel.specialdefense)
        self.speed = Int(coreDataModel.speed)
    }

    init?(with fragment: EvYieldsFragment?) {
        guard let fragment else { return nil }
        self.attack = Int(fragment.attack)
        self.defense = Int(fragment.defense)
        self.hp = Int(fragment.hp)
        self.specialattack = Int(fragment.specialattack)
        self.specialdefense = Int(fragment.specialdefense)
        self.speed = Int(fragment.speed)
    }
}
