//
//  CoreDataContextProvider.swift
//  StorageService
//
//  Created by Павел Барташов on 01.09.2022.
//

//https://www.userdesk.io/blog/repository-pattern-using-core-data-and-swift/
import CoreData

public final class CoreDataContextProvider {

    public static let shared = CoreDataContextProvider()

    /// Returns the current container view context
    public var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    /// The persistent container
    private var persistentContainer: NSPersistentContainer
    
    public init(completionClosure: ((Error?) -> Void)? = nil) {
        // Create a persistent container
        guard let bundle = Bundle(identifier: "pB.StorageService"),
              let url = bundle.url(forResource: "Navigation", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: url)
        else {
            fatalError("Failed to load Core Data model")
        }

        persistentContainer = NSPersistentContainer(name: "Navigation", managedObjectModel: model)
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
                
            }
            completionClosure?(error)
        }
    }

    /// Creates a context for background work
    public func newBackgroundContext() -> NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
}
