//
//  TestPostSevice.swift
//  Navigation
//
//  Created by Павел Барташов on 25.06.2022.
//

import StorageService

final class TestPostService: PostServiceProtocol {
    let mockNetworkRequstSucceeded = true

    func getPosts(comletion: @escaping (Result<[Post], PostServiceError>) -> Void) {
        DispatchQueue.global().async { [weak self] in
            if self?.mockNetworkRequstSucceeded == true {
                comletion(.success(Post.demoPosts))
            } else {
                comletion(.failure(.networkFailure))
            }
        }
    }
}
