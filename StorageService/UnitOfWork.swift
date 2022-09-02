//
//  UnitOfWork.swift
//  StorageService
//
//  Created by Павел Барташов on 01.09.2022.
//

import CoreData

//https://www.userdesk.io/blog/repository-pattern-using-core-data-and-swift/
final class UnitOfWork {
    /// The NSManagedObjectContext instance to be used for performing the unit of work.
    private let context: NSManagedObjectContext

    /// Post repository instance.
    let postRepository: PostRepository

    /// Designated initializer.
    /// - Parameter managedObjectContext: The NSManagedObjectContext instance to be used for performing the unit of work.
    init(context: NSManagedObjectContext) {
        self.context = context
        self.postRepository = PostRepository(context: context)
    }

    /// Save the NSManagedObjectContext.
    @discardableResult func saveChanges() -> Result<Bool, Error> {
        do {
            try context.save()
            return .success(true)
        } catch {
            context.rollback()
            return .failure(error)
        }
    }
}
