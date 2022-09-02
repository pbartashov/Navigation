//
//  PostEntity+.swift
//  StorageService
//
//  Created by Павел Барташов on 01.09.2022.
//

import CoreData

//https://www.userdesk.io/blog/repository-pattern-using-core-data-and-swift/
extension PostEntity: DomainModel {
    typealias DomainModelType = Post
    
    func toDomainModel() -> Post {
        Post(url: url ?? "",
             author: author ?? "",
             description: postDescription ?? "",
             image: image ?? "",
             likes: Int(likes),
             views: Int(views))
    }

    func copyDomainModel(model: Post) {
        url = model.url
        author = model.author
        postDescription = model.description
        image = model.image
        likes = Int32(model.likes)
        views = Int32(model.views)
    }

}
