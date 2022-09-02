//
//  CoreDataStorable.swift
//  StorageService
//
//  Created by Павел Барташов on 01.09.2022.
//

import CoreData

protocol CoreDataStorable: Storable {
    static var entityType: NSManagedObject.Type { get }

    func createEntity(with context: NSManagedObjectContext) -> NSManagedObject
}
