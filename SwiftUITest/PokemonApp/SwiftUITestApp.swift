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
            PokemonListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.network, Dependencies.serviceClient)
                .environmentObject(viewModel)
                .onAppear {
                    viewModel.setup()
                }
        }
    }
}
