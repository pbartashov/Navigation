//
//  ProfileViewModel.swift
//  Navigation
//
//  Created by Павел Барташов on 25.06.2022.
//

import StorageService

enum ProfileAction {
    case requstPosts
    case showPhotos
    case store(post: Post)
    case showError(Error)
}

enum ProfileState {
    case initial
    case loaded([Post])
}

protocol ProfileViewModelProtocol: ViewModelProtocol
    where State == ProfileState,
          Action == ProfileAction {

    var posts: [Post] { get }
    var user: User? { get }
}

final class ProfileViewModel: ViewModel<ProfileState, ProfileAction>,
                              ProfileViewModelProtocol {
    //MARK: - Properties

    private weak var coordinator: ProfileCoordinator?

    private let favoritesPostRepository: PostRepositoryInterface

    private let userService: UserService
    private let userName: String
    var user: User? {
        userService.getUser(byName: userName)
    }

    private let postService: PostServiceProtocol
    var posts: [Post] = [] {
        didSet {
            state = .loaded(posts)
        }
    }

    //MARK: - LifeCicle

    init(postService: PostServiceProtocol,
         coordinator: ProfileCoordinator,
         userService: UserService,
         userName: String,
         postRepository: PostRepositoryInterface) {
        
        self.postService = postService
        self.coordinator = coordinator
        self.userService = userService
        self.userName = userName
        self.favoritesPostRepository = postRepository

        super.init(state: .initial)
    }

    //MARK: - Metods

    override func perfomAction(_ action: ProfileAction) {
        switch action {
            case .requstPosts:
                postService.getPosts { [weak self] result in
                    switch result {
                        case .success(let posts):
                            self?.posts = posts
                            
                        case .failure(let error):
                            ErrorPresenter.shared.show(error: error)
                    }
                }
            case .showPhotos:
                coordinator?.showPhotos()

            case .store(let post):
                store(post: post)

            case .showError(let error):
                ErrorPresenter.shared.show(error: error)
        }
    }

    private func store(post: Post) {
        favoritesPostRepository.save(post: post)
        favoritesPostRepository.saveChanges()
    }
}
