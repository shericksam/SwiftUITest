//
//  TypeMatchupModel.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 09/07/23.
//

import Foundation

struct TypeMatchupModel {
    var attacking: TypeEffectivenessModel?
    var defending: TypeEffectivenessModel?

    init?(with coreDataModel: TypeMatchup?) {
        guard let coreDataModel else { return nil }
        self.attacking = TypeEffectivenessModel(with: coreDataModel.attacking)
        self.defending = TypeEffectivenessModel(with: coreDataModel.defending)
    }
}
