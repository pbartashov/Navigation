////
////  Strorable.swift
////  Navigation
////
////  Created by Павел Барташов on 28.08.2022.
////
//
////https://github.com/tfsaidov/DatabaseDemo/tree/CoreData
//import RealmSwift
//import CoreData
//
//
//
//import StorageService
//
//protocol Storable1 {}
////
////extension Object: Storable {}
////extension NSManagedObject: Storable {}
//
//protocol CoreDataStorable: Storable {
////    associatedtype CoreDataDBType
//
//
////    init?(from managedObject: NSManagedObject)
////    func createManagedObject(for context: NSManagedObjectContext) -> NSManagedObject
//    var associatedDatabaseType: NSManagedObject.Type { get }
//
////    func getAssociatedDatabaseType<T>() -> T.Type
////    func copy(to managedObject: inout NSManagedObject)
//
//
////    static func getAssociatedDatabaseType() -> NSManagedObject.Type
//}
//
//protocol RealmStorable: Storable {
//
////    associatedtype RealmDBType
//
//
//    init?(from realmObject: Object)
//    func createRealmObject() -> Object
////    var associatedDatabaseType: Object.Type { get }
//    //    func copy(to managedObject: inout NSManagedObject)
//    func getAssociatedDatabaseType() -> Object.Type
//}
//
//
//
//
//
//protocol DatabaseObject {
//
//}
//
//extension Object: DatabaseObject {}
//extension NSManagedObject: DatabaseObject {}
//
//
//protocol Storable {
//    // Объект базы данных, соответствующий объекту модели
////    func databaseObjectType(for dataBase: DataBase) -> DatabaseObject.Type
////    var databaseObjectType: T where T: DatabaseObject.Type
////    func getSomething<T>() -> T? where T: SomeProtocol {
////        return someValue as? T
////    }
//    // Заполняет объект базы данных свойствами объекта модели
//    var storeId: Int { get }
////    func copy<T: DatabaseObject>(to databaseObject: inout T)
//    func copy(to databaseObject: inout DatabaseObject)
//
//    init?(from: DatabaseObject)
//}
//
//
//extension Post: Storable {
//    var storeId: Int {
//        url.hashValue
//    }
//
//    init?(from databaseObject: DatabaseObject) {
//        guard let entity = databaseObject as? PostEntity else { return nil }
//
//        self.init(url: entity.url ?? "",
//                  author: entity.author ?? "",
//                  description: entity.postDescription ?? "",
//                  image: entity.image ?? "",
//                  likes: Int(entity.likes),
//                  views: Int(entity.views))
//    }
//
//    func copy(to databaseObject: inout DatabaseObject) {
//    //    func copy<T>(to databaseObject: inout T) where T : DatabaseObject {
//
//        //    func copy(to databaseObject: inout NSManagedObject) {
//        guard let entity = databaseObject as? PostEntity else { return }
//
//        entity.setValue(url, forKey: #keyPath(PostEntity.url))
//        entity.setValue(author, forKey: #keyPath(PostEntity.author))
//        entity.setValue(description, forKey: #keyPath(PostEntity.postDescription))
//        entity.setValue(image, forKey: #keyPath(PostEntity.image))
//        entity.setValue(Int32(likes), forKey: #keyPath(PostEntity.likes))
//        entity.setValue(Int32(views), forKey: #keyPath(PostEntity.views))
//        entity.setValue(Int64(storeId), forKey: #keyPath(PostEntity.storeId))
//
//    }
//}
//
//
//enum RealmDB {
//    static let objectType = Object.self
//}
//
//enum CoreDataDB {
//    static let objectType = NSManagedObject.self
//}
//
//extension Post: CoreDataStorable {
//
//
////    typealias CoreDataDBType = PostEntity
//
//
//
//    var associatedDatabaseType: NSManagedObject.Type {
//        PostEntity.self
//    }
//
////    static func getAssociatedDatabaseType() -> NSManagedObject.Type {
////
////        PostEntity.self
////    }
//
//
////    typealias AssociatedDatabaseType = PostEntity
//
//
////    typealias AssociatedDatabaseType = PostEntity
////    var associatedDatabaseType: NSManagedObject.Type {
////        PostEntity.self
////    }
//
////    func getAssociatedDatabaseType() -> PostEntity.Type {
////        PostEntity.self
////    }
//
//
//
//
//
//
//
//
//
//
//
////    init?(from managedObject: NSManagedObject) {
////        guard let entity = managedObject as? PostEntity else { return nil }
////
////        self.init(url: entity.url ?? "",
////                  author: entity.author ?? "",
////                  description: entity.postDescription ?? "",
////                  image: entity.image ?? "",
////                  likes: Int(entity.likes),
////                  views: Int(entity.views))
////    }
//
//
////    func createManagedObject(for context: NSManagedObjectContext) -> DatabaseObject {
////        var entity: DatabaseObject = PostEntity(context: context)
////        self.copy(to: &entity)
////        return entity
////    }
//
//
//}
//
//extension Post: RealmStorable {
//
//
//    typealias RealmDBType = Object
//
//    func getAssociatedDatabaseType() -> Object.Type {
//        Object.self
//    }
//
//
//
//    init?(from realmObject: Object) {
//        self.init(url: "")
//    }
//
//    func createRealmObject() -> Object {
//        Object()
//    }
//
////    var associatedDatabaseType: Object.Type {
////        Object().self
////    }
//
//
//}
//
//
//
//
//extension NSManagedObject: Storable1 {}
