//
//  DataSourceGenericError.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 09/07/23.
//

import Foundation

enum DataSourceGenericError: Error {
    case DataSourceError, CreateError, DeleteError, UpdateError, FetchError
}
