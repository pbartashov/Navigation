//
//  FavoritePostsViewModel.swift
//  Navigation
//
//  Created by Павел Барташов on 02.09.2022.
//

import StorageService

final class FavoritesViewModel: ViewModel<ProfileState, ProfileAction>,
                                ProfileViewModelProtocol {
    //MARK: - Properties

    private let favoritesPostRepository: PostRepositoryInterface

    var user: User?

    var posts: [Post] = [] {
        didSet {
            state = .loaded(posts)
        }
    }

    //MARK: - LifeCicle

    init(postRepository: PostRepositoryInterface) {
        self.favoritesPostRepository = postRepository

        super.init(state: .initial)
    }

    //MARK: - Metods

    override func perfomAction(_ action: ProfileAction) {
        switch action {
            case .requstPosts:
                requstPosts()

            case .selected(let post):
                favoritesPostRepository.delete(post: post)
                favoritesPostRepository.saveChanges()
                requstPosts()

            case .showError(let error):
                ErrorPresenter.shared.show(error: error)

            default:
                break
        }

        func requstPosts() {
            let result = favoritesPostRepository.getPosts(predicate: nil)

            switch result {
                case .success(let posts):
                    self.posts = posts

                case .failure(let error):
                    ErrorPresenter.shared.show(error: error)
            }
        }
    }
}
