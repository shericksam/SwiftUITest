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
            if let sprite = evolution.sprite {
                Image(sprite)
                    .resizable()
                    .frame(width: 40, height: 40)
            }

            Text(evolution.species ?? "")

            if let evolutionLevel = evolution.evolutionLevel {
                Text("Level \(evolutionLevel)")
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4)
    }
}

