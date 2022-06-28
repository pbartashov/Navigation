//
//  ProfileViewModel.swift
//  Navigation
//
//  Created by Павел Барташов on 25.06.2022.
//

import StorageService

enum Action {
    case requstPosts
    case showPhotos
}

enum State {
    case initial
    case loaded([Post])
}

protocol ProfileViewModelProtocol {
    var posts: [Post] { get }
    var user: User? { get }
    var stateChanged: ((State) -> Void)? { get set }

    func perfomAction(_ action: Action)
}

final class ProfileViewModel: ProfileViewModelProtocol {

    //MARK: - Properties

    private weak var coordinator: ProfileCoordinator?

    private let userService: UserService
    private let userName: String
    var user: User? {
        userService.getUser(byName: userName)
    }

    var stateChanged: ((State) -> Void)?
    private var state: State = .initial {
        didSet {
            stateChanged?(state)
        }
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
    }

    //MARK: - Metods

    func perfomAction(_ action: Action) {
        switch action {
            case .requstPosts:
                posts = postService.getPosts()
            case .showPhotos:
                coordinator?.showPhotos()
        }
    }
}
