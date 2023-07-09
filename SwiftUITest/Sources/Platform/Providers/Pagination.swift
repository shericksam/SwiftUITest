//
//  Pagination.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 09/07/23.
//

import Foundation

protocol Pagination {
    associatedtype Element
    var items: [Element] { get set }
    var pageSize: Int { get set }
    var startingIndex: Int? { get set }
    var triggerIndex: Int? { get set }
}


struct PaginationImp: Pagination {
    typealias Element = PokemonListingItem
    var items: [Element]
    var pageSize: Int
    var startingIndex: Int?
    var triggerIndex: Int?
}
