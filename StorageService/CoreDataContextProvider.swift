//
//  CoreDataContextProvider.swift
//  StorageService
//
//  Created by Павел Барташов on 01.09.2022.
//

//https://www.userdesk.io/blog/repository-pattern-using-core-data-and-swift/
import CoreData

public final class CoreDataContextProvider {
    // Returns the current container view context
    public var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // The persistent container
    private var persistentContainer: NSPersistentContainer
    
    public init(completionClosure: ((Error?) -> Void)? = nil) {
        // Create a persistent container
        persistentContainer = NSPersistentContainer(name: "Navigation")
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
                
            }
            completionClosure?(error)
        }
    }
    // Creates a context for background work
    func newBackgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
}
