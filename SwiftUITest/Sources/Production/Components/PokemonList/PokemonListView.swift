//
//  PokemonListView.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 06/07/23.
//

import SwiftUI
import CoreData

struct PokemonListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var queryHolder: QueryHolder<AllPokemonQuery>
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.num, ascending: true)],
        animation: .default)
    private var pokemon: FetchedResults<Pokemon>
    @StateObject private var viewModel = PokemonListViewModel()

    public init() {
        self.queryHolder = QueryHolder(
            query: AllPokemonQuery(offset: 89)
        )
    }
    var body: some View {
        NavigationView {
            ZStack {
                NetworkStatusView()
                List {
                    ForEach(pokemon) { pokemonItem in
                        NavigationLink {
                            Text("Item at \(pokemonItem.num)")
                        } label: {
                            Text("Item at \(pokemonItem.key ?? "")")
                        }
                    }
                }
                if viewModel.loadingState == .loading {
                    LoadingView()
                }
                if viewModel.loadingState == .error {
                    ErrorView(errorMessage: viewModel.errorMessage, retryAction: { viewModel.retry(queryHolder.query) })
                }
            }
            .environmentObject(queryHolder)
            .onReceive(queryHolder.$query) { query in
                viewModel.executeQuery(query)
            }
        }
    }
}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView()
    }
}

//            List {

//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//            Text("Select an item")
