//
//  SwiftUITestApp.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 06/07/23.
//

import SwiftUI

@main
struct SwiftUITestApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var viewModel = PokemonAppViewModel()

    var body: some Scene {
        WindowGroup {
            PokemonListView(provider: Dependencies.pokemonProvider)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(viewModel)
                .onAppear {
                    viewModel.setup()
                }
        }
    }
}
