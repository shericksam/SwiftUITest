//
//  ExplorerURLProvider.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 06/07/23.
//

import Foundation

class ExplorerURLProvider: ServerURLProvider {
    func getServerUrl() -> URL {
        ActiveServerUrl.getServerUrl()
    }
}

enum ServerUrl: String {
    case production = "https://graphqlpokemon.favware.tech/v7"
    case integration = ""
}

struct ActiveServerUrl {
    static var serverUrl: ServerUrl?

    static func set(serverUrl: ServerUrl = .production) {
        self.serverUrl = serverUrl
    }

    static func getGraphQLServiceUrl() -> URL {
        return getServerUrl()
    }

    static func getServerUrl() -> URL {
        return URL(string: serverUrl!.rawValue)!
    }

    static func getEnvironmentPrettyName(_ environment: ServerUrl?) -> String {
        switch environment {
        case .production: return "Production"
        case .integration: return "Integration"
        default: return "Unknown"
        }
    }

    static func toggleEnvironment() {
        ActiveServerUrl.serverUrl = (ActiveServerUrl.serverUrl == .production) ? (.integration) : (.production)
    }

}
