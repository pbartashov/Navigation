//
//  PostRepository.swift
//  StorageService
//
//  Created by Павел Барташов on 01.09.2022.
//

import CoreData

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
    /// Get Posts using a predicate
    public func getPosts(predicate: NSPredicate?) async throws -> [Post] {
        let postEntity = try await repository.get(predicate: predicate, sortDescriptors: nil)
        // Transform the NSManagedObject objects to domain objects
        let posts = postEntity.map { PostEntity -> Post in
            return PostEntity.toDomainModel()
        }
        return posts
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
}
