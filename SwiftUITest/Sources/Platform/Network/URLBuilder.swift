//
//  URLBuilder.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 06/07/23.
//

import Foundation

public protocol ServerURLProvider {
    func getServerUrl() -> URL
}

protocol URLBuilder {
    func url(path: String) -> URL?
}

struct URLBuilderImpl: URLBuilder {
    private let serverUrl: URL
    init(serverUrl: ServerURLProvider = Dependencies.serverUrlProvider) {
        self.serverUrl = serverUrl.getServerUrl()
    }

    func url(path: String) -> URL? {
        return URL(string: path, relativeTo: serverUrl)
    }
}
