//
//  DomainModel.swift
//  StorageService
//
//  Created by Павел Барташов on 01.09.2022.
//

import CoreData

//https://www.userdesk.io/blog/repository-pattern-using-core-data-and-swift/
protocol DomainModel {
    associatedtype DomainModelType
    func toDomainModel() -> DomainModelType
    func copyDomainModel(model: DomainModelType)
}
