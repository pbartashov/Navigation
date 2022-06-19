//
//  ViewControllerFactory.swift
//  Navigation
//
//  Created by Павел Барташов on 18.06.2022.
//

import UIKit

struct ViewControllerFactory {
    static var create = ViewControllerFactory()

    func rootViewController(with delegate: LoginViewControllerDelegate) -> UIViewController {

        let feedViewController = FeedViewController()
        feedViewController.tabBarItem = UITabBarItem(title: "Feed",
                                                     image: UIImage(systemName: "house.fill"),
                                                     tag: 0)

        let loginViewController = LoginViewController()
        loginViewController.delegate = delegate
        loginViewController.tabBarItem = UITabBarItem(title: "Profile",
                                                      image: UIImage(systemName: "person.fill"),
                                                      tag: 1)

        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .systemGray6

        tabBarController.setViewControllers(
            [UINavigationController(rootViewController: feedViewController),
             UINavigationController(rootViewController: loginViewController)],
            animated: true)

        tabBarController.selectedIndex = 1

        return tabBarController
    }

    func profileViewController(for userName: String) -> UIViewController {
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
