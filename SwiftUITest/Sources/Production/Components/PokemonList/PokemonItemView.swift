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
                    .frame(width: 60, height: 60)
                    .scaledToFit()
            }
            Spacer()
            VStack {
                Text(pokemon.key ?? "no-name")
                    .font(Font.custom("PokemonGb", size: 18))
                if let types = pokemon.types {
                    HStack {
                        ForEach(types) { type in
                            if let typeName = type.name {
                                Text(typeName)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 2)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(PokemonColors.getColor(for: typeName))
                                    )
                            }
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
