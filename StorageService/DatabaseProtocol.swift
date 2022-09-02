//
//  DatabaseProtocol.swift
//  StorageService
//
//  Created by Павел Барташов on 01.09.2022.
//

protocol DatabaseProtocol {
    associatedtype StorableType
    associatedtype DataBaseObjectType

//    func create(object: StorableType)
//    func delete(object: StorableType)
//    func fetchAll() -> [DataBaseObjectType]


    func create(_ object: StorableType) async throws -> DataBaseObjectType
    func delete(_ object: StorableType) async throws -> DataBaseObjectType
    
    func fetch<T>(ofType objectType: T.Type, with predicate: NSPredicate?) async throws -> [DataBaseObjectType]
    func fetchAll<T>(ofType objectType: T.Type) async throws -> [DataBaseObjectType]
}
