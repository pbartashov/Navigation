//
//  FavoritePostsViewModel.swift
//  Navigation
//
//  Created by Павел Барташов on 02.09.2022.
//

import StorageService

final class FavoritesViewModel: PostsViewModel {

    //MARK: - Properties

    private let favoritesPostRepository: PostRepositoryInterface

    //MARK: - LifeCicle

    init(postRepository: PostRepositoryInterface) {
        self.favoritesPostRepository = postRepository
        super.init()

        setupHandlers()
    }

    //MARK: - Metods

    private func setupHandlers() {
        requstPosts = { [weak self] in
            guard let self = self else { return }
            let result = self.favoritesPostRepository.getPosts(predicate: nil)

            switch result {
                case .success(let posts):
                    self.posts = posts

                case .failure(let error):
                    ErrorPresenter.shared.show(error: error)
            }
        }

        onPostSelected = { [weak self] post in
            self?.favoritesPostRepository.delete(post: post)
            self?.favoritesPostRepository.saveChanges()
            self?.requstPosts?()
        }
    }
}
