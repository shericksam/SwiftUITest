//
//  NetworkEnvironment.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 06/07/23.
//

import Foundation
import SwiftUI

private struct NetworkKey: EnvironmentKey {
    static var defaultValue: ApolloServiceClientProvider {
        Dependencies.serviceClient
    }
}

extension EnvironmentValues {
    var network: ApolloServiceClientProvider {
        get { self[NetworkKey.self] }
        set { self[NetworkKey.self] = newValue }
    }
}

extension View {
    func network(_ network: ApolloServiceClientProvider) -> some View {
        environment(\.network, network)
    }
}

