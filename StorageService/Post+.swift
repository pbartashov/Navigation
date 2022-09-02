//
//  Post+.swift
//  StorageService
//
//  Created by Павел Барташов on 01.09.2022.
//

import CoreData

extension Post: Storable {
    var storeId: Int {
        url.hashValue
    }
}


extension Post: CoreDataStorable {
    static var entityType: NSManagedObject.Type {
        PostEntity.self
    }

    func createEntity(with context: NSManagedObjectContext) -> NSManagedObject {
        PostEntity(context: context)
    }


}
