//
//  StatsModel.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 09/07/23.
//

import Foundation

struct StatsModel {
    var attack: Int
    var defense: Int
    var hp: Int
    var specialattack: Int
    var specialdefense: Int
    var speed: Int

    init?(with coreDataModel: Stats?) {
        guard let coreDataModel else { return nil }
        self.attack = Int(coreDataModel.attack)
        self.defense = Int(coreDataModel.defense)
        self.hp = Int(coreDataModel.hp)
        self.specialattack = Int(coreDataModel.specialattack)
        self.specialdefense = Int(coreDataModel.specialdefense)
        self.speed = Int(coreDataModel.speed)
    }
}
