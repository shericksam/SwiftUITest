//
//  PokemonListView.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 06/07/23.
//

import SwiftUI
import CoreData

struct PokemonListView: View {
    @ObservedObject var viewModel: PokemonListViewModel

    var body: some View {
        VStack {
            NavigationView {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.items) { pokemonItem in
                            NavigationLink {
                                PokemonDetailView(pokemon: pokemonItem.listing)
                                    .environmentObject(viewModel)
                            } label: {
                                PokemonItemView(pokemon: pokemonItem.listing)
                            }
                            .onAppear {
                                viewModel.fetchNextPageIfNeeded(for: pokemonItem)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
                .navigationTitle("pokedex")
                .navigationViewStyle(StackNavigationViewStyle())
            }
            NetworkStatusView()
        }
    }
}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView(viewModel: PokemonListViewModel())
    }
}
