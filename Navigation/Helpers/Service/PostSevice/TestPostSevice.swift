//
//  TestPostSevice.swift
//  Navigation
//
//  Created by Павел Барташов on 25.06.2022.
//

import StorageService

final class TestPostService: PostServiceProtocol {
    func getPosts() -> [Post] {
        Post.demoPosts
    }
}
