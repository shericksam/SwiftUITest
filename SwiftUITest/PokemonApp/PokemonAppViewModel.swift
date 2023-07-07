//
//  PokemonAppViewModel.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 06/07/23.
//

import Combine
import SwiftUI

@MainActor
final class PokemonAppViewModel: ObservableObject {
    func setup() {
        ActiveServerUrl.set()
    }
}

