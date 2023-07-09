//
//  TypeEffectivenessModel.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 09/07/23.
//

import Foundation

struct TypeEffectivenessModel {
    var doubleEffectiveTypes: [String]?
    var doubleResistedTypes: [String]?
    var effectiveTypes: [String]?
    var effectlessTypes: [String]?
    var normalTypes: [String]?
    var resistedTypes: [String]?

    init?(with coreDataModel: TypeEffectiveness?) {
        guard let coreDataModel else { return nil }
        self.doubleEffectiveTypes = coreDataModel.doubleEffectiveTypes as? [String]
        self.doubleResistedTypes = coreDataModel.doubleResistedTypes as? [String]
        self.effectiveTypes = coreDataModel.effectiveTypes as? [String]
        self.effectlessTypes = coreDataModel.effectlessTypes as? [String]
        self.normalTypes = coreDataModel.normalTypes as? [String]
        self.resistedTypes = coreDataModel.resistedTypes as? [String]
    }
}
