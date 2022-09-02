//
//  CoreDataService.swift
//  Navigation
//
//  Created by Павел Барташов on 28.08.2022.
//

import Foundation
import CoreData
import StorageService

//https://github.com/tfsaidov/DatabaseDemo/tree/CoreData
final class CoreDataService {

    // MARK: - Properties

        let modelName: String
    //
    //    private let model: NSManagedObjectModel
    private let persistentStoreCoordinator: NSPersistentStoreCoordinator

    private lazy var mainContext: NSManagedObjectContext = {
        let mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return mainContext
    }()

    // MARK: - LifeCicle

    init(name: String, bundle: Bundle = Bundle.main) throws {
        guard let url = bundle.url(forResource: name, withExtension: "momd") else {
            fatalError("Can't find \(name).xcdatamodelId in bundle \(bundle)")
        }

        guard let model = NSManagedObjectModel(contentsOf: url) else {
            throw DatabaseError.store(model: name)
        }

                self.modelName = name
        //        self.model = model
        self.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)

        try setup(with: name)
    }

    // MARK: - Metods

    private func setup(with modelName: String) throws {
        let fileManager = FileManager.default
        let storeName = "\(modelName).sqlite"

        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let persistentStoreURL = documentsDirectoryURL?.appendingPathComponent(storeName)

        do {
            let options = [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true
            ]

            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: options)
        } catch {
            throw DatabaseError.store(model: modelName)
        }
    }
}

//extension CoreDataService: DatabaseProtocol {
//
//    func create<T>(_ model: T.Type, keyedValues: [[String : Any]], completion: @escaping (Result<[T], DatabaseError>) -> Void) where T : Storable {
//        ()
//    }
//
//
//    func create<T>(object: T) async throws where T : Storable {
//        try await mainContext.perform { [weak self] in
//            guard let self = self,
//                  let object = object as? CoreDataStorable else { return }
//
//
//            let entity = object.createManagedObject(for: self.mainContext)
//
//            guard self.mainContext.hasChanges else {
//                throw DatabaseError.store(model: String(describing: entity.self))
//            }
//
//            do {
//                try self.mainContext.save()
//            } catch let error {
//                throw DatabaseError.error(desription: "Unable to save changes of main context.\nError - \(error.localizedDescription)")
//            }
//        }
//    }
//
//    func update<T>(_ model: T.Type, predicate: NSPredicate?, keyedValues: [String: Any], completion: @escaping (Result<[T], DatabaseError>) -> Void) where T : Storable {
//        self.fetch(model, predicate: predicate) { [weak self] result in
//            guard let self = self else { return }
//
//            switch result {
//                case .success(let fetchedObjects):
//                    guard let fetchedObjects = fetchedObjects as? [NSManagedObject] else {
//                        return
//                    }
//
//                    self.mainContext.perform {
//                        fetchedObjects.forEach { fetchedObject in
//                            fetchedObject.setValuesForKeys(keyedValues)
//                        }
//
//                        let castFetchedObjects = fetchedObjects as? [T] ?? []
//
//                        guard self.mainContext.hasChanges else {
//                            completion(.failure(.store(model: String(describing: model.self))))
//                            return
//                        }
//
//                        do {
//                            try self.mainContext.save()
//                            completion(.success(castFetchedObjects))
//                        } catch let error {
//                            completion(.failure(.error(desription: "Unable to save changes of main context.\nError - \(error.localizedDescription)")))
//                        }
//                    }
//                case .failure(let error):
//                    completion(.failure(error))
//            }
//        }
//    }
//
//    func delete<T>(_ model: T.Type, predicate: NSPredicate?, completion: @escaping (Result<[T], DatabaseError>) -> Void) where T : Storable {
//        self.fetch(model, predicate: predicate) { [weak self] result in
//            guard let self = self else { return }
//
//            switch result {
//                case .success(let fetchedObjects):
//                    guard let fetchedObjects = fetchedObjects as? [NSManagedObject] else {
//                        completion(.failure(.wrongModel))
//                        return
//                    }
//
//                    self.mainContext.perform {
//                        fetchedObjects.forEach { fetchedObject in
//                            self.mainContext.delete(fetchedObject)
//                        }
//                        let deletedObjects = fetchedObjects as? [T] ?? []
//
//                        guard self.mainContext.hasChanges else {
//                            completion(.failure(.store(model: String(describing: model.self))))
//                            return
//                        }
//
//                        do {
//                            try self.mainContext.save()
//                            completion(.success(deletedObjects))
//                        } catch let error {
//                            completion(.failure(.error(desription: "Unable to save changes of main context.\nError - \(error.localizedDescription)")))
//                        }
//                    }
//                case .failure(let error):
//                    completion(.failure(error))
//            }
//        }
//    }
//
//    func deleteAll<T>(_ model: T.Type, completion: @escaping (Result<[T], DatabaseError>) -> Void) where T : Storable {
//        self.delete(model, predicate: nil, completion: completion)
//    }
//
//    //func fetch<T>(_ model: T.Type, predicate: NSPredicate?, completion: @escaping (Result<[T], DatabaseError>) -> Void) where T : Storable {
//    func fetch<T: DatabaseObject>(with predicate: NSPredicate?) async throws -> [T] {
//        try await mainContext.perform { [weak self] in
//            guard let self = self,
//                  let object = T.self as? CoreDataStorable else { return [] }
//
//
//            let entity = object.createManagedObject(for: self.mainContext)
//
//            let request = NSFetchRequest<PostEntity>()
//
//            request.predicate = predicate
//
//            guard
//                let fetchRequestResult = try? self.mainContext.fetch(request),
//                let fetchedObjects = fetchRequestResult as? [T]
//            else {
//                throw DatabaseError.failure(.wrongModel)
//            }
//
//            completion(.success(fetchedObjects))
//        }
//    }
//
//    func fetchAll<T>(_ model: T.Type, completion: @escaping (Result<[T], DatabaseError>) -> Void) where T : Storable {
//        self.fetch(model, predicate: nil, completion: completion)
//    }
//}

//extension CoreDataService: DatabaseProtocol1{
//    func save<T>(object: DBStorable) -> T where T : DatabaseObject {
//        object.createManagedObject(for: <#T##NSManagedObjectContext#>)
//    }
//
//    func fetchAll<T>() -> T where T : DatabaseObject {
//
//    }
//
//
//
//    typealias DBStorable = CoreDataStorable
//
//}
//
//extension CoreDataService: DatabaseProtocol2 {
//    func fetchAll(objectOfType: DBStorable.Protocol) {
//        objectOfType.
//    }
//
//
//
//    func save(object: DBStorable) {
//        object.createManagedObject(for: mainContext)
//    }
//
//    typealias DBStorable = CoreDataStorable
//
//
//}
//
//
//final class RealmService {
//}
//
////extension RealmService: DatabaseProtocol1{
////    func save<T>(object: DBStorable) -> T where T : DatabaseObject {
////
////    }
////
////    func fetchAll<T>() -> T where T : DatabaseObject {
////
////    }
////
////
////
////    typealias DBStorable = CoreDataStorable
////
////}
//
//
//protocol DatabaseProtocol1 {
//    //    associatedtype DBObject
//    associatedtype DBStorable
//
//    func fetchAll<T: DatabaseObject>() -> T
//    func save<T: DatabaseObject>(object: DBStorable) -> T
//
//
//}
//
//
//protocol DatabaseProtocol2 {
//    //    associatedtype DBObject
//    associatedtype DBStorable
//
//    func fetchAll(objectOfType: DBStorable.Type)
//
//    func fetchAll(objectOfType: DBStorable)
//    func create(object: DBStorable) async throws
//
//}
//
//
//
////extension CoreDataService: DatabaseProtocol2 {
////    func fetchAll(objectOfType: DBStorable) {
////        ()
////    }
////
////    typealias DBStorable = CoreDataStorable
////
////
////    func fetchAll(objectOfType: DBStorable.Type) {
////
////        objectOfType.getAssociatedDatabaseType().fetchRequest()
////
////
////    }
////
////    func fetchAll(objectOfType: DBStorable.Protocol) {
////
////    }
////
////
////
////    func create(object: DBStorable) async throws {
////        try await mainContext.perform { [weak self] in
////            guard let self = self else { return }
////
////
////            let entity = object.createManagedObject(for: self.mainContext)
////
////            guard self.mainContext.hasChanges else {
////                throw DatabaseError.store(model: String(describing: entity.self))
////            }
////
////            do {
////                try self.mainContext.save()
////            } catch let error {
////                throw DatabaseError.error(desription: "Unable to save changes of main context.\nError - \(error.localizedDescription)")
////            }
////        }
////    }
////
////
////
////
////}
//
//
//protocol DatabaseProtocol3 {
//    //    associatedtype DBObject
////    associatedtype DBStorable
//
////    func fetchAll<T: Storable>(objectOfType: T.Type)
//    func fetch<T: Storable>(ofType objectType: T.Type, with predicate: NSPredicate?) async throws -> [DatabaseObject]
//    func fetchAll<T: Storable>(ofType: T.Type) async throws -> [DatabaseObject]
//
//
//    func create(_ object: Storable) async throws -> DatabaseObject
//    func update(_ databaseObject: DatabaseObject) async throws -> DatabaseObject
//
//}
//
//
//extension CoreDataService: DatabaseProtocol3 {
//    func update(_ databaseObject: DatabaseObject) async throws -> DatabaseObject {
//PostEntity()
//    }
//
//    
//
//    func fetchAll<T>(ofType objectType: T.Type) async throws -> [DatabaseObject] where T : Storable {
//        try await fetch(ofType: objectType, with: nil)
//    }
//
//    func fetch<T>(ofType objectType: T.Type, with predicate: NSPredicate?) async throws -> [DatabaseObject] where T : Storable {
//        try await mainContext.perform { [weak self] in
//            guard
//                let self = self,
//                let objectType = objectType as? CoreDataStorable.Type
//            else {
//                throw DatabaseError.wrongModel
//            }
//
////            let request = objectType.init(from: PostEntity())!.associatedDatabaseType.fetchRequest()
//            let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: String(describing: PostEntity.self))
//            request.predicate = predicate
//
//            guard
//                let fetchRequestResult = try? self.mainContext.fetch(request),
//                let fetchedObjects = fetchRequestResult as? [DatabaseObject]
//            else {
//                throw DatabaseError.wrongModel
//            }
//
//            return fetchedObjects
//        }
//    }
//
//
//
//
//
//    func create(_ object: Storable) async throws -> DatabaseObject {
//        try await mainContext.perform { [weak self] in
//            guard
//                let self = self,
//                let object = object as? CoreDataStorable
//            else {
//                throw DatabaseError.wrongModel
//            }
//
//            let entity = object.associatedDatabaseType.init(context: self.mainContext)
//
//            try self.saveContext()
//
//            return entity
//        }
//    }
//
//
//    private func saveContext() throws {
//        guard self.mainContext.hasChanges else {
//            throw DatabaseError.store(model: modelName)
//        }
//
//        do {
//            try self.mainContext.save()
//        } catch let error {
//            throw DatabaseError.error(desription: "Unable to save changes of main context.\nError - \(error.localizedDescription)")
//        }
//    }
//
//
//
//}
