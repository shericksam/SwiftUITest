//
//  Pagination.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 09/07/23.
//

import Foundation

protocol Pagination {
    var items: Int { get set }
    var pageSize: Int { get set }
    var startingIndex: Int? { get set }
    var triggerIndex: Int? { get set }
}


struct PaginationImp: Pagination {
    var items: Int
    var pageSize: Int
    var startingIndex: Int?
    var triggerIndex: Int?
}
