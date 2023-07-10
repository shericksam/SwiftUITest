//
//  PokemonItemView.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 06/07/23.
//

import Apollo
import Foundation
import SwiftUI

struct PokemonItemView: View {
    var pokemon: PokemonModel
    
    var body: some View {
        HStack {
            if let gifURL = URL(string: pokemon.sprite ?? "") {
                GIFImageView(gifURL: gifURL)
                    .frame(width: 50, height: 50)
            }
            VStack {
                Text(pokemon.key ?? "no-name")
                if let types = pokemon.types {
                    HStack {
                        ForEach(types) { type in
                            Text(type.name ?? "no-name")
                        }
                    }
                }
            }
        }
        .padding()
    }
}


struct PokemonItemView_Previews: PreviewProvider {
    static var previewData = LightDataFragmentWithoutNested(key: .bulbasaur, num: 1, species: "bulbasaur", sprite: "https://play.pokemonshowdown.com/sprites/ani/bulbasaur.gif", types: [.init(name: "Grass")])
    static var previews: some View {
        PokemonItemView(pokemon: PokemonModel(with: previewData))
    }
}
