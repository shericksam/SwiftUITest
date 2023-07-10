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
                if let pokemonKey = pokemon.key {
                    Text(pokemonKey.localizedCapitalized)
                        .font(Font.custom("PokemonGb", size: 18))
                }
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
        .background(Color.color(from: pokemon.color ?? "gray")?.convertToLigthColor())
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

 
struct PokemonItemView_Previews: PreviewProvider {
    static var previewData = LightDataFragmentWithoutNested(key: .bulbasaur, num: 1, species: "bulbasaur", sprite: "https://play.pokemonshowdown.com/sprites/ani/bulbasaur.gif", color: "blue", types: [.init(name: "Grass")])
    static var previews: some View {
        PokemonItemView(pokemon: PokemonModel(with: previewData))
    }
}
