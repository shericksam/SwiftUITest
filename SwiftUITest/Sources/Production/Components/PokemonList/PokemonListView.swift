//
//  PokemonListView.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 06/07/23.
//

import SwiftUI
import CoreData

struct PokemonListView: View {
    @StateObject private var viewModel = PokemonListViewModel()
    @ObservedObject var provider: PokemonPaginatedItemProvider

    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(provider.items) { pokemonItem in
                        NavigationLink {
                            Text("Item at \(pokemonItem.listing.num)")
                        } label: {
                            VStack {
                                Text("Num at \(pokemonItem.listing.num)")
                                Text("Key at \(pokemonItem.listing.key ?? "")")
                                Text("Species at \(pokemonItem.listing.species ?? "")")
                            }
                        }
                        .onAppear {
                            provider.fetchNextPageIfNeeded(for: pokemonItem)
                        }
                    }
                }
            }
            .navigationTitle("pokedex")
            .navigationViewStyle(StackNavigationViewStyle())
            NetworkStatusView()
        }
    }
}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView(provider: PokemonPaginatedItemProvider(items: [], size: 20))
    }
}
