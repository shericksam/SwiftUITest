//
//  QueryHolder.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 06/07/23.
//

import Apollo
import Foundation

class QueryHolder<Query: GraphQLQuery>: ObservableObject {
    @Published var query: Query

    init(query: Query) {
        self.query = query
    }

    func reload(with query: Query) {
        self.query = query
    }
}

