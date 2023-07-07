//
//  PokemonListView.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 06/07/23.
//

import Apollo
import Foundation
import SwiftUI

extension AllPokemonQuery.Data: View {
    public var body: some View {
        ScrollView {
            ForEach(getAllPokemon.indices, id: \.self) { index in
                VStack {
                    Text(getAllPokemon[index].key.rawValue)
                    Text("\(getAllPokemon[index].num)")
                }
                .padding()
            }
        }
        .padding()
    }
}


//struct AllPokemonList_Previews: PreviewProvider {
//    static var previews: some View {
//        PropertyAvailabilityCalendarsQuery.allExamples()
//    }
//}
