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
    // Get a post using a predicate
    func getPosts(predicate: NSPredicate?) -> Result<[Post], Error>
    // Creates a Post on the persistance layer.
    @discardableResult func create(post: Post) -> Result<Bool, Error>
    // Creates or Updates existing Post on the persistance layer.
    @discardableResult func save(post: Post) -> Result<Bool, Error>
    // Deletes a Post from the persistance layer.
    @discardableResult func delete(post: Post) -> Result<Bool, Error>
    /// Saves changes to Repository.
    @discardableResult func saveChanges() -> Result<Bool, Error>
}

// Post Repository class.
public final class PostRepository {
    // The Core Data Post repository.
    private let repository: CoreDataRepository<PostEntity>

    /// Designated initializer
    /// - Parameter context: The context used for storing and quering Core Data.
    public init(context: NSManagedObjectContext) {
        self.repository = CoreDataRepository<PostEntity>(managedObjectContext: context)
    }
}

extension PostRepository: PostRepositoryInterface {
    // Get Posts using a predicate
    public func getPosts(predicate: NSPredicate?) -> Result<[Post], Error> {
        let result = repository.get(predicate: predicate, sortDescriptors: nil)
        switch result {
            case .success(let postEntity):
                // Transform the NSManagedObject objects to domain objects
                let posts = postEntity.map { PostEntity -> Post in
                    return PostEntity.toDomainModel()
                }

                return .success(posts)
            case .failure(let error):
                // Return the Core Data error.
                return .failure(error)
        }
    }

    // Creates a Post on the persistance layer.
    @discardableResult public func create(post: Post) -> Result<Bool, Error> {
        let result = repository.create()
        switch result {
            case .success(let postEntity):
                // Update the Post properties.
                postEntity.copyDomainModel(model: post)
                return .success(true)

            case .failure(let error):
                // Return the Core Data error.
                return .failure(error)
        }
    }

    // Deletes a Post from the persistance layer.
    @discardableResult public func delete(post: Post) -> Result<Bool, Error> {
        let result = getPostEntity(for: post)
        switch result {
            case .success(let postEntity):
                // Delete the PostEntity.
                return repository.delete(entity: postEntity)
            case .failure(let error):
                // Return the Core Data error.
                return .failure(error)
        }
    }

    // Creates or Updates existing Post on the persistance layer.
    @discardableResult public func save(post: Post) -> Result<Bool, Error> {
        let result = getPostEntity(for: post)
        switch result {
            case .success(let postEntity):
                // Update the Post properties.
                postEntity.copyDomainModel(model: post)
                return .success(true)
            case .failure(let error):
                if case DatabaseError.notFound = error {
                    // Create the PostEntity.
                    return create(post: post)
                }
                // Return the Core Data error.
                return .failure(error)
        }
    }

    private func getPostEntity(for post: Post) -> Result<PostEntity, Error> {
        let predicate = NSPredicate(format: "url == %@", post.url)
        let result = repository.get(predicate: predicate, sortDescriptors: nil)
        switch result {
            case .success(let postEntities):
                guard let postEntity = postEntities.first else {
                    return .failure(DatabaseError.notFound)
                }
                // Return PostEntity.
                return .success(postEntity)
            case .failure(let error):
                // Return the Core Data error.
                return .failure(error)
        }
    }

    /// Save the NSManagedObjectContext.
    @discardableResult public func saveChanges() -> Result<Bool, Error> {
        repository.saveChanges()
    }
}


#warning("Return the Core Data error")
