//
//  RealmDatabase.swift
//  StorageService
//
//  Created by Павел Барташов on 01.09.2022.
//

//import RealmSwift


class Object {}

struct RealmDataBase: DatabaseProtocol {
    func create(_ object: Storable) async throws -> Object {
        Object()
    }

    func delete(_ object: Storable) async throws -> Object {
        Object()
    }

    func fetch<T>(ofType objectType: T.Type, with predicate: NSPredicate?) async throws -> [Object] {
        [Object()]
    }

    typealias DataBaseObjectType = Object

    typealias StorableType = RealmStorable
    //func save<T>(object: T) {
    func save(object: StorableType) {
        print("RealmDataBase \(object.storeId)")
//        print(object.realmObject)
    }
}
