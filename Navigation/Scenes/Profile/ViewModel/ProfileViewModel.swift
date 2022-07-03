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
                DispatchQueue.global().async { [self] in
                    posts = postService.getPosts()
                }
            case .showPhotos:
                coordinator?.showPhotos()
        }
    }
}
