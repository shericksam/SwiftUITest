//
//  LoadingState.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 06/07/23.
//

import Foundation

public enum LoadingState {
    case loading, loaded, error
}

public class LoadingStatePublisher: ObservableObject {
    @Published public var loadingState: LoadingState = .loading
}
