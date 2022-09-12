//
//  PostRepository.swift
//  StorageService
//
//  Created by Павел Барташов on 01.09.2022.
//

import CoreData


import UIKit

//https://www.userdesk.io/blog/repository-pattern-using-core-data-and-swift/
/// Protocol that describes a Post repository.
public protocol PostRepositoryInterface {
    /// Get a post using a predicate
    func getPosts(predicate: NSPredicate?) async throws -> [Post]
    /// Creates a Post on the persistance layer.
    func create(post: Post) async throws
    /// Creates or Updates existing Post on the persistance layer.
    func save(post: Post) async throws
    /// Deletes a Post from the persistance layer.
    func delete(post: Post) async throws
    /// Saves changes to Repository.
    func saveChanges() async throws
    
    
    
    var fetchResults: [Post] { get }
    
    func setupResultsControllerStateChangedHandler(stateChanged:((FetchResultServiceState) -> Void)?)
    
    func startFetchingWith(predicate: NSPredicate?,
                           sortDescriptors: [NSSortDescriptor]?) throws
}

/// Post Repository class.
public final class PostRepository {
    /// The Core Data Post repository.
    private let repository: CoreDataRepository<PostEntity>
    
    /// Designated initializer
    /// - Parameter context: The context used for storing and quering Core Data.
    public init(context: NSManagedObjectContext) {
        self.repository = CoreDataRepository<PostEntity>(managedObjectContext: context)
    }
}

extension PostRepository: PostRepositoryInterface {
    
    public var fetchResults: [Post] {
        mapToPosts(postEntities: repository.fetchResults)
    }
    
    private func mapToPosts(postEntities: [PostEntity]) -> [Post] {
        postEntities.map { $0.toDomainModel() }
    }
    
    /// Get Posts using a predicate
    public func getPosts(predicate: NSPredicate?) async throws -> [Post] {
        let postEntities = try await repository.get(predicate: predicate, sortDescriptors: nil)
        // Transform the NSManagedObject objects to domain objects
        return mapToPosts(postEntities: postEntities)
    }
    
    /// Creates a Post on the persistance layer.
    public func create(post: Post) async throws {
        let postEntity = try await repository.create()
        postEntity.copyDomainModel(model: post)
    }
    
    /// Deletes a Post from the persistance layer.
    public func delete(post: Post) async throws {
        let postEntity = try await getPostEntity(for: post)
        await repository.delete(entity: postEntity)
    }
    
    /// Creates or Updates existing Post on the persistance layer.
    public func save(post: Post) async throws {
        try await create(post: post)
    }
    
    private func getPostEntity(for post: Post) async throws -> PostEntity {
        let predicate = NSPredicate(format: "url == %@", post.url)
        let postEntities = try await repository.get(predicate: predicate, sortDescriptors: nil)
        guard let postEntity = postEntities.first else {
            throw DatabaseError.notFound
        }
        return postEntity
    }
    
    /// Save the NSManagedObjectContext.
    public func saveChanges() async throws {
        try await repository.saveChanges()
    }
    
    /// Sets up a FetchResultService with stateChanged handler.
    public func setupResultsControllerStateChangedHandler(stateChanged:((FetchResultServiceState) -> Void)?) {
        repository.setupResultsControllerStateChangedHandler(stateChanged: stateChanged)
    }
    
    /// Starts fetching with given NSPredicate and array of NSSortDescriptors.
    public func startFetchingWith(predicate: NSPredicate?,
                                  sortDescriptors: [NSSortDescriptor]?) throws {
        var sorting = sortDescriptors
        if sorting == nil {
            sorting = [NSSortDescriptor(keyPath: \PostEntity.author, ascending: true)]
        }
        
        try repository.startFetchingWith(predicate: predicate, sortDescriptors: sorting)
    }
}
