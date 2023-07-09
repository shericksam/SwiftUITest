//
//  ManagedObject.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 08/07/23.
//

import Foundation
import CoreData

class ManagedObject: NSManagedObject {
    @NSManaged var idString: String
}

protocol ManagedObjectSupport {}
extension ManagedObject: ManagedObjectSupport {}

extension ManagedObjectSupport where Self: ManagedObject {
    // Creates or retrieves an object with the specified id
    static func object(in context: NSManagedObjectContext, withId id: String) -> Self {
        let request = Self.fetchRequest() as! NSFetchRequest<Self>
        request.predicate = NSPredicate(format: "%K == %@",  #keyPath(idString), id)
        request.fetchLimit = 1
        request.returnsObjectsAsFaults = false

        switch (try? context.fetch(request))?.first {
        case .some(let object):
            return object

        case .none:
            let newObject = Self(context: context)
            newObject.idString = id
            return newObject
        }
    }

    // Returns an existing object with the specified id
    static func existingObject(in context: NSManagedObjectContext, withId id: String) -> Self? {
        let request = Self.fetchRequest() as! NSFetchRequest<Self>
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(idString), id)
        request.fetchLimit = 1
        request.returnsObjectsAsFaults = false
        return (try? context.fetch(request))?.first
    }

    // Configure and return a fetched results controller
    static func fetchedResultsController(in context: NSManagedObjectContext,
                                         sortDescriptors: [NSSortDescriptor]? = nil,
                                         predicate: NSPredicate? = nil,
                                         sectionKeyPath: String? = nil) -> NSFetchedResultsController<Self> {
        let request = Self.fetchRequest() as! NSFetchRequest<Self>
        request.sortDescriptors = sortDescriptors
        request.predicate = predicate
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: context,
                                          sectionNameKeyPath: sectionKeyPath, cacheName: nil)
    }
}
