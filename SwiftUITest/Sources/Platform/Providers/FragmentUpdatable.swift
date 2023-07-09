//
//  FragmentUpdatable.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 08/07/23.
//

import Foundation
import Apollo
import CoreData

//protocol FragmentUpdatable {
//    associatedtype Fragment: GraphQLFragment & Identifiable
//    func update(with fragment: Fragment)
//}
//
//extension FragmentUpdatable where Self: ManagedObject {
//    static func object(in context: NSManagedObjectContext, withFragment fragment: Self.Fragment?) -> Self? {
//        guard let fragment = fragment, let id = fragment.id as? String else { return nil }
//        let object = Self.object(in: context, withId: id)
//        object.update(with: fragment)
//        return object
//    }
//}
