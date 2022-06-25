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

    func feedViewController(tag: Int) -> UIViewController {

        let feedViewController = FeedViewController(model: FeedViewControllerModel())
        feedViewController.tabBarItem = UITabBarItem(title: "Feed",
                                                     image: UIImage(systemName: "house.fill"),
                                                     tag: tag)

        return feedViewController
    }

    func loginViewController(with delegate: LoginViewControllerDelegate, tag: Int) -> UIViewController {
        let loginViewController = LoginViewController()
        loginViewController.delegate = delegate
        loginViewController.tabBarItem = UITabBarItem(title: "Profile",
                                                      image: UIImage(systemName: "person.fill"),
                                                      tag: tag)
        return loginViewController
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
