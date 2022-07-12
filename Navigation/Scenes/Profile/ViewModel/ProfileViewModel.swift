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
    func getUser() throws -> User
}

final class ProfileViewModel: ViewModel<ProfileState, ProfileAction>,
                              ProfileViewModelProtocol {
    //MARK: - Properties

    private weak var coordinator: ProfileCoordinator?

    private let userService: UserService
    private let userName: String
    func getUser() throws -> User {
        try userService.getUser(byName: userName)
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
         userName: String) {
        
        self.postService = postService
        self.coordinator = coordinator
        self.userService = userService
        self.userName = userName

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

            case .showError(let error):
                ErrorPresenter.shared.show(error: error)
        }
    }
}
