//
//  StorageService.swift
//  Navigation
//
//  Created by Павел Барташов on 30.08.2022.
//

import Foundation
import StorageService




protocol StorageServiceProtocol {
//    associatedtype DatabaseType



    func save<T: Storable>(object: T) async throws
    func delete<T: Storable>(object: T) async throws
    func fetchAll<T: Storable>() async throws -> [T]
}



struct StorageService: StorageServiceProtocol {
//typealias DatabaseType = CoreDataService

    // MARK: - Properties
    private let database: DatabaseProtocol3 = try! CoreDataService(name: "Navigation")

    // MARK: - Views

    // MARK: - LifeCicle

    // MARK: - Metods

    func save<T>(object: T) async throws where T: Storable {
        let predicate = NSPredicate(format: "storeId == %ld", object.storeId)
//        self.databaseCoordinator.update(ArticleCoreDataModel.self, predicate: predicate, keyedValues: keyedValues) { result in

//        let objects: [PostEntity] = try await database.fetch(with: predicate)

        if var savedObject = try await database
                .fetch(ofType: type(of: object), with: predicate)
                .first {

            object.copy(to: &savedObject)
            try await database.update(savedObject)
        } else {
            try await database.create(object)
        }

//        object.createManagedObject(for: <#T##NSManagedObjectContext#>)

//        if !object.isEmpty {
//
//        }
//        CoreDataStorable.
//        DatabaseType.

    }

    func delete<T>(object: T) async throws where T: Storable {
        ()
    }

    func fetchAll<T>() async throws -> [T] where T: Storable {
        try await database.fetchAll(ofType: T.self).compactMap { T.init(from: $0) }
    }


}
