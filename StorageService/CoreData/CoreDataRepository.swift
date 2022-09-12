//
//  CoreDataRepository.swift
//  StorageService
//
//  Created by Павел Барташов on 01.09.2022.
//

import CoreData



import UIKit

//https://www.userdesk.io/blog/repository-pattern-using-core-data-and-swift/
/// Generic class for handling NSManagedObject subclasses.
final class CoreDataRepository<T: NSManagedObject>: Repository {
    typealias Entity = T
    
    /// The NSManagedObjectContext instance to be used for performing the operations.
    private let context: NSManagedObjectContext

    /// Service for managing automatic fetches.
    private let fetchResultService: FetchResultService

    /// Automatic fetching results.
    var fetchResults: [T] {
        fetchResultService.results as? [T] ?? []
    }

    /// Designated initializer.
    /// - Parameter managedObjectContext: The NSManagedObjectContext instance to be used for performing the operations.
    init(managedObjectContext: NSManagedObjectContext) {
        self.context = managedObjectContext
        self.context.mergePolicy = NSOverwriteMergePolicy
        self.fetchResultService = FetchResultService(context: managedObjectContext)
    }
    
    /// Gets an array of NSManagedObject entities.
    /// - Parameters:
    ///   - predicate: The predicate to be used for fetching the entities.
    ///   - sortDescriptors: The sort descriptors used for sorting the returned array of entities.
    /// - Returns: A result consisting of NSManagedObject entities.
    func get(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) async throws -> [Entity] {
        try await context.perform { [weak self] in
            // Create a fetch request for the associated NSManagedObjectContext type.
            let fetchRequest = Entity.fetchRequest()
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = sortDescriptors

            let fetchResults = try self?.context.fetch(fetchRequest)

            if let results = fetchResults as? [Entity] {
                return results
            } else {
                throw DatabaseError.invalidManagedObjectType
            }
        }
    }
    
    /// Creates a NSManagedObject entity.
    /// - Returns: A result consisting of a NSManagedObject entity.
    func create() async throws -> Entity {
        try await context.perform { [weak self] in
            let className = String(describing: Entity.self)
            guard let self = self,
                  let managedObject = NSEntityDescription.insertNewObject(forEntityName: className,
                                                                          into: self.context) as? Entity
            else {
                throw DatabaseError.invalidManagedObjectType
            }
            return managedObject
        }
    }
    
    /// Deletes a NSManagedObject entity.
    /// - Parameter entity: The NSManagedObject to be deleted.
    func delete(entity: Entity) async {
        await context.perform { [weak self] in
            self?.context.delete(entity)
        }
    }

    /// Save the NSManagedObjectContext.
    func saveChanges() async throws {
        try await context.perform { [weak self] in
            do {
                try self?.context.save()
            } catch {
                self?.context.rollback()
                throw error
            }
        }
    }

    /// Sets up a FetchResultService with stateChanged handler.
    /// - Parameter stateChanged: Closure engaged on FetchResultService state changed.
    func setupResultsControllerStateChangedHandler(stateChanged:((FetchResultServiceState) -> Void)?) {
        fetchResultService.stateChanged = stateChanged
    }

    /// Starts fetching with given NSPredicate and array of NSSortDescriptors.
    /// - Parameters:
    ///   - predicate: The predicate to be used for fetching the entities.
    ///   - sortDescriptors: The sort descriptors used for sorting the returned array of entities.
    func startFetchingWith(predicate: NSPredicate?,
                           sortDescriptors: [NSSortDescriptor]?) throws {
        let fetchRequest = Entity.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        
        try fetchResultService.startFetching(with: fetchRequest)
    }
}
