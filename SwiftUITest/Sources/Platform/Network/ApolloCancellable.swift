//
//  ApolloCancellable.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 06/07/23.
//

import Apollo

public struct ApolloCancellable: Cancellable {
    let apolloCancellable: Apollo.Cancellable?
    public init(apolloCancellable: Apollo.Cancellable?) {
        self.apolloCancellable = apolloCancellable
    }

    public func cancel() {
        apolloCancellable?.cancel()
    }
}

