//
//  ComponentFactory.swift
//  Navigation
//
//  Created by Павел Барташов on 15.06.2022.
//

import UIKit

struct ComponentFactory {
    static func createButton(withTitle title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue

        button.layer.cornerRadius = 14

        button.layer.shadowOffset = .init(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7

        return button
    }

    static func createRootViewController(with delegate: LoginViewControllerDelegate) -> UIViewController {

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
}


