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

    func viewModelWith(coordinator: ProfileCoordinator?,
                       userName: String
    ) -> ProfileViewModel {

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
        let postRepository = PostRepository(context: contextProvider.viewContext)
        
        return ProfileViewModel(postService: postService,
                                coordinator: coordinator,
                                userService: userService,
                                userName: userName,
                                postRepository: postRepository)
    }
    
    func viewControllerWith(viewModel: ProfileViewModel) -> UIViewController {
        ProfileViewController(viewModel: viewModel)
    }
}
