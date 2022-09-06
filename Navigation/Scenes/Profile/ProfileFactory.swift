//
//  ProfileFactory.swift
//  Navigation
//
//  Created by Павел Барташов on 25.06.2022.
//

import UIKit
import StorageService

struct ProfileFactory {

    //MARK: - Properties

    static var create = ProfileFactory()

    //MARK: - Metods

    func viewModelWith(profileCoordinator: ProfileCoordinator?,
                       postsCoordinator: PostsCoordinator?,
                       userName: String
    ) -> ProfileViewModel<PostsViewModel> {

#if DEBUG
        let userService = TestUserService()
#else
        let user = User(name: userName,
                        avatar: (UIImage(named: "profileImage") ?? UIImage(systemName: "person"))!,
                        status: "Hardly coding")
        let userService = CurrentUserService(currentUser: user)
#endif
        let postService = TestPostService()

        let contextProvider = CoreDataContextProvider.shared
        let postRepository = PostRepository(context: contextProvider.newBackgroundContext())
        let postsViewModel = PostsViewModel(coordinator: postsCoordinator)
        
        return ProfileViewModel(postService: postService,
                                coordinator: profileCoordinator,
                                userService: userService,
                                userName: userName,
                                postRepository: postRepository,
                                postsViewModel: postsViewModel)
    }
    
    func viewControllerWith<T>(viewModel: ProfileViewModel<T>) -> UIViewController where T: PostsViewModelProtocol {
        ProfileViewController<ProfileViewModel<T>, T>(viewModel: viewModel)
    }
}
