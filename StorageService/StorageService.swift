//
//  StorageService.swift
//  StorageService
//
//  Created by Павел Барташов on 01.09.2022.
//

import Foundation


struct StorageService<DataBase: DatabaseProtocol> {
    // MARK: - Properties
    let dataBase: DataBase


    // MARK: - LifeCicle
    init(dataBase: DataBase) {
        self.dataBase = dataBase
    }

    // MARK: - Metods


    func save(object: DataBase.StorableType) async throws {

        try await dataBase.create(object)
    }

    func delete(object: DataBase.StorableType) async throws {
        try await dataBase.delete(object)
    }

    func fetchAll<T: Storable>() async throws -> [T] {
        try await dataBase.fetchAll(ofType: T.Type)
            .map { T.init(from: $0 ) }
    }

    
}
