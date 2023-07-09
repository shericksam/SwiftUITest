//
//  GenderModel.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 09/07/23.
//

import Foundation

struct GenderModel {
    var female: String?
    var male: String?

    init?(with coreDataModel: Gender?) {
        guard let coreDataModel else { return nil }
        self.female = coreDataModel.female
        self.male = coreDataModel.male
    }

    init?(with fragment: GenderFragment?) {
        guard let fragment else { return nil }
        self.female = fragment.female
        self.male = fragment.male
    }
}
