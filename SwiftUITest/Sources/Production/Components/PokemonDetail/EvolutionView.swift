//
//  EvolutionView.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 09/07/23.
//

import SwiftUI

struct EvolutionView: View {
    let evolution: PokemonModel

    var body: some View {
        HStack {
            if let sprite = evolution.sprite, let url = URL(string: sprite) {
                GIFImageViewRep(gifURL: url)
                    .frame(width: 40, height: 40)
                    .aspectRatio(contentMode: .fit)
            }
            Spacer()
            Text(evolution.species ?? "")

            if let evolutionLevel = evolution.evolutionLevel {
                Text("Level \(evolutionLevel)")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .padding(.vertical, 4)
    }
}

