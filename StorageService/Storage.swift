//
//  Storage.swift
//  StorageService
//
//  Created by Павел Барташов on 01.09.2022.
//

class Storage {
    static let shared = Storage()
    let service = StorageService(dataBase: RealmDataBase())
}
