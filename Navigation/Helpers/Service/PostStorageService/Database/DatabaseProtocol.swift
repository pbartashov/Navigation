//
//  DatabaseProtocol.swift
//  Navigation
//
//  Created by Павел Барташов on 28.08.2022.
//

import Foundation

//https://github.com/tfsaidov/DatabaseDemo/tree/CoreData
protocol DatabaseProtocol {
    /// Создание объекта заданного типа.
//    func store<T: Storable>(_ model: T, keyedValues: [[String: Any]], completion: @escaping (Result<[T], DatabaseError>) -> Void)
    func create<T: Storable>(object: T) throws

    func create<T: Storable>(_ model: T.Type, keyedValues: [[String: Any]], completion: @escaping (Result<[T], DatabaseError>) -> Void)

    /// Обновление объекта заданного типа с помощью предиката.
    func update<T: Storable>(_ model: T.Type, predicate: NSPredicate?, keyedValues: [String: Any], completion: @escaping (Result<[T], DatabaseError>) -> Void)
    /// Удаление объектов заданного типа с помощью предиката.
    func delete<T: Storable>(_ model: T.Type, predicate: NSPredicate?, completion: @escaping (Result<[T], DatabaseError>) -> Void)
    /// Удаление всех объектов заданного типа.
    func deleteAll<T: Storable>(_ model: T.Type, completion: @escaping (Result<[T], DatabaseError>) -> Void)
    /// Получение объектов заданного типа с помощью предиката.
    func fetch<T: Storable>(_ model: T.Type, predicate: NSPredicate?, completion: @escaping (Result<[T], DatabaseError>) -> Void)

    func fetch<T: Storable>(with predicate: NSPredicate?) async throws -> [T]

    /// Получение объектов заданного типа.
    func fetchAll<T: Storable>(_ model: T.Type, completion: @escaping (Result<[T], DatabaseError>) -> Void)
}

