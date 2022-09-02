//
//  CoreDataBase.swift
//  StorageService
//
//  Created by Павел Барташов on 01.09.2022.
//

import CoreData

//https://github.com/tfsaidov/DatabaseDemo/tree/CoreData
final class CoreDataBase {

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

extension CoreDataBase: DatabaseProtocol {




    typealias StorableType = CoreDataStorable
    typealias DatabaseObjectType = NSManagedObject

    // MARK: - Properties

    // MARK: - Views

    // MARK: - LifeCicle

    // MARK: - Metods

//    func save(object: StorableType) {
////        print("CoreDataBase \(object.storeId)")
////        print(object.entityType)
//    }
//
//    func delete(object: StorableType) {
//
//    }
//
//    func fetchAll() -> [DatabaseObjectType] {
//
//    }


    func fetchAll(ofType objectType: StorableType.Protocol) async throws -> [DatabaseObjectType] {
        try await fetch(ofType: objectType, with: nil)
    }

    func fetch<T>(ofType objectType: T.Type, with predicate: NSPredicate?) async throws -> [DataBaseObjectType] {
//    func fetch(ofType objectType: StorableType.Protocol, with predicate: NSPredicate?) async throws -> [DatabaseObjectType] {
        try await mainContext.perform { [weak self] in
            guard
                let self = self,






                    
                let objectType = objectType as? CoreDataStorable.Type
            else {
                return []
            }

            let request = objectType.entityType.fetchRequest()
//            let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: String(describing: PostEntity.self))
            request.predicate = predicate

            guard
                let fetchRequestResult = try? self.mainContext.fetch(request),
                let fetchedObjects = fetchRequestResult as? [DatabaseObjectType]
            else {
                throw DatabaseError.wrongModel
            }

            return fetchedObjects
        }
    }





    func create(_ object: StorableType) async throws -> DatabaseObjectType {
        try await mainContext.perform { [weak self] in
            guard
                let self = self,
                let object = object as? CoreDataStorable
            else {
                throw DatabaseError.wrongModel
            }

            let entity = object.createEntity(with: self.mainContext)

            try self.saveContext()

            return entity
        }
    }

    func delete(_ object: StorableType) async throws -> DatabaseObjectType {
        NSManagedObject()
    }

    private func saveContext() throws {
        guard self.mainContext.hasChanges else {
            throw DatabaseError.store(model: modelName)
        }

        do {
            try self.mainContext.save()
        } catch let error {
            throw DatabaseError.error(desription: "Unable to save changes of main context.\nError - \(error.localizedDescription)")
        }
    }
}
