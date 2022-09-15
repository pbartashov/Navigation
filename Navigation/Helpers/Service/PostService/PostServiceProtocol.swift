//
//  PostService.swift
//  Navigation
//
//  Created by Павел Барташов on 25.06.2022.
//

import StorageService

protocol PostServiceProtocol {
    func getPosts(comletion: @escaping (Result<[Post], PostServiceError>) -> Void)
}
