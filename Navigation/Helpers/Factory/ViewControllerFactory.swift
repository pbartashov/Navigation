//
//  ViewControllerFactory.swift
//  Navigation
//
//  Created by Павел Барташов on 18.06.2022.
//

import UIKit

struct ViewControllerFactory {

    //MARK: - Properties

    static var create = ViewControllerFactory()

    //MARK: - Metods

    func tabBarController(with viewControllers: [UIViewController]) -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .systemGray6

        tabBarController.setViewControllers(viewControllers, animated: true)

        return tabBarController
    }

    func feedViewController(tag: Int) -> FeedViewController {

        let feedViewController = FeedViewController(model: FeedViewControllerModel())
        feedViewController.tabBarItem = UITabBarItem(title: "Feed",
                                                     image: UIImage(systemName: "house.fill"),
                                                     tag: tag)
        return feedViewController
    }

    func loginViewController(with delegate: LoginViewControllerDelegate, tag: Int) -> LoginViewController {
        let loginViewController = LoginViewController()
        loginViewController.delegate = delegate
        loginViewController.tabBarItem = UITabBarItem(title: "Profile",
                                                      image: UIImage(systemName: "person.fill"),
                                                      tag: tag)
        return loginViewController
    }


    func profileViewController(for userName: String) -> ProfileViewController {
#if DEBUG
        let userService = TestUserService()
#else
        let user = User(name: "Octopus",
                        avatar: (UIImage(named: "profileImage") ?? UIImage(systemName: "person"))!,
                        status: "Hardly coding")
        let userService = CurrentUserService(currentUser: user)
#endif
        return ProfileViewController(userService: userService, userName: userName)
    }
}
