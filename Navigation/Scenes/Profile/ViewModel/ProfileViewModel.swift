//
//  ProfileViewModel.swift
//  Navigation
//
//  Created by Павел Барташов on 25.06.2022.
//

import StorageService

enum ProfileAction {
    case showPhotos
    case posts(action: PostsAction)
}

enum ProfileState {
    case initial
}

protocol ProfileViewModelProtocol: ViewModelProtocol
where State == ProfileState,
      Action == ProfileAction {

    associatedtype PostsViewModelType: PostsViewModelProtocol

    var postsViewModel: PostsViewModelType { get }
    var user: User? { get }
}

final class ProfileViewModel<T>: ViewModel<ProfileState, ProfileAction>,
                                 ProfileViewModelProtocol where T: PostsViewModelProtocol{
    typealias PostsViewModelType = T

    //MARK: - Properties

    private weak var coordinator: ProfileCoordinator?

    private let favoritesPostRepository: PostRepositoryInterface
    private let postService: PostServiceProtocol
    var postsViewModel: PostsViewModelType

    private let userService: UserService
    private let userName: String
    var user: User? {
        userService.getUser(byName: userName)
    }

    //MARK: - LifeCicle

    init(postService: PostServiceProtocol,
         coordinator: ProfileCoordinator?,
         userService: UserService,
         userName: String,
         postRepository: PostRepositoryInterface,
         postsViewModel: PostsViewModelType) {
        
        self.postService = postService
        self.coordinator = coordinator
        self.userService = userService
        self.userName = userName
        self.favoritesPostRepository = postRepository
        self.postsViewModel = postsViewModel

        super.init(state: .initial)

        setupViewModel()
    }

    //MARK: - Metods

    private func setupViewModel() {
        postsViewModel.onPostSelected = { post in
            Task { [weak self] in
                do {
                    try await self?.favoritesPostRepository.save(post: post)
                    try await self?.favoritesPostRepository.saveChanges()
                } catch {
                    ErrorPresenter.shared.show(error: error)
                }
            }
        }

        postsViewModel.requstPosts = { [weak self] in
            self?.postService.getPosts { [weak self] result in
                switch result {
                    case .success(var posts):
                        if var text = self?.postsViewModel.searchText {
                            text = text.lowercased()
                            posts = posts.filter { $0.author.lowercased().contains(text)}
                        }
                        self?.postsViewModel.posts = posts

                    case .failure(let error):
                        ErrorPresenter.shared.show(error: error)
                }
            }
        }
    }

    override func perfomAction(_ action: ProfileAction) {
        switch action {
            case .showPhotos:
                coordinator?.showPhotos()

            case .posts(let action):
                postsViewModel.perfomAction(action)
        }
    }
}
