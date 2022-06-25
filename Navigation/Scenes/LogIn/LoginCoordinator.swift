//
//  LiginCoordinator.swift
//  Navigation
//
//  Created by Павел Барташов on 25.06.2022.
//

import UIKit

final class LoginCoordinator: NavigationCoordinator {

    //MARK: - Properties

    private let profileCoordinator: ProfileCoordinator

    //MARK: - LifeCicle

    override init(navigationController: UINavigationController) {
        self.profileCoordinator = ProfileCoordinator(navigationController: navigationController)
        super.init(navigationController: navigationController)
    }

    //MARK: - Metods

    func showProfile(for userName: String) {
        let profileViewModel = ProfileFactory.create.viewModelWith(coordinator: profileCoordinator,
                                                                   userName: userName)

        let profileViewController = ProfileFactory.create.viewControllerWith(viewModel: profileViewModel)
        
        navigationController?.pushViewController(profileViewController, animated: true)
    }
}
