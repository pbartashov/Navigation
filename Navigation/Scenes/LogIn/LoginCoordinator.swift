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
        let profileViewController = ViewControllerFactory.create.profileViewController(for: userName)
        profileViewController.coordinator = profileCoordinator
        
        navigationController?.pushViewController(profileViewController, animated: true)
    }
}
