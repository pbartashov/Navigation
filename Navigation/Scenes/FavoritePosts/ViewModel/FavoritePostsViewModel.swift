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

    init(postRepository: PostRepositoryInterface,
         coordinator: PostsCoordinator?) {
        
        self.favoritesPostRepository = postRepository
        super.init(coordinator: coordinator)

        setupHandlers()
    }

    //MARK: - Metods

    private func setupHandlers() {
        requstPosts = { [weak self] in
            Task { [weak self] in
                guard let self = self else { return }
                do {
                    var predicate: NSPredicate? = nil
                    if let text = self.searchText {
                        predicate = NSPredicate(format: "author CONTAINS[c] %@", text)
                    }
                    try self.favoritesPostRepository.startFetchingWith(predicate: predicate,
                                                                       sortDescriptors: nil)

                    self.posts = self.favoritesPostRepository.fetchResults
                } catch {
                    ErrorPresenter.shared.show(error: error)
                }
            }
        }

        deletePost = { indexPath in
            Task { [weak self] in
                do {
                    guard let self = self else { return }
                    let post = self.posts[indexPath.row]
                    try await self.favoritesPostRepository.delete(post: post)
                    try await self.favoritesPostRepository.saveChanges()
                } catch {
                    ErrorPresenter.shared.show(error: error)
                }
            }
        }

        favoritesPostRepository.setupResultsControllerStateChangedHandler { [weak self] state in
            switch state {
                case .didChangeContent:
                    guard let self = self else { return }
                    self.posts = self.favoritesPostRepository.fetchResults

                default:
                    break
            }
        }
    }
}
