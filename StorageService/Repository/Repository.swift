//
//  Repository.swift
//  StorageService
//
//  Created by Павел Барташов on 01.09.2022.
//

import CoreData

//https://www.userdesk.io/blog/repository-pattern-using-core-data-and-swift/
protocol Repository {
    /// The entity managed by the repository.
    associatedtype Entity

    /// Gets an array of entities.
    /// - Parameters:
    ///   - predicate: The predicate to be used for fetching the entities.
    ///   - sortDescriptors: The sort descriptors used for sorting the returned array of entities.
    func get(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) async throws -> [Entity]

    /// Creates an entity.
    func create() async throws -> Entity

    /// Deletes an entity.
    /// - Parameter entity: The entity to be deleted.
    func delete(entity: Entity) async

    /// Saves changes to Repository.
    func saveChanges() async throws

    /// Automatic fetching results.
    var fetchResults: [Entity] { get }

    /// Sets up a FetchResultService with stateChanged handler.
    func setupResultsControllerStateChangedHandler(stateChanged:((FetchResultServiceState) -> Void)?)

    /// Starts fetching with given NSPredicate and array of NSSortDescriptors.
    func startFetchingWith(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) throws
}
