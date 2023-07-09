//
//  PokemonTypeModel.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 09/07/23.
//

import Foundation

struct PokemonTypeModel: Identifiable {
    let id: UUID = UUID()
    var name: String?
    var matchup: TypeMatchupModel?

    init?(with coreDataModel: PokemonType?) {
        guard let coreDataModel else { return nil }
        self.name = coreDataModel.name
        self.matchup = TypeMatchupModel(with: coreDataModel.matchup)
    }
    
    init(name: String) {
        self.name = name
    }

    init?(with fragment: PokemonTypeFragment?) {
        guard let fragment else { return nil }
        self.name = fragment.name
        self.matchup = TypeMatchupModel(with: fragment.matchup.fragments.typeMatchupFragment)
    }
}
