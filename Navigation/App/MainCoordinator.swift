//
//  MainCoordinator.swift
//  Navigation
//
//  Created by Павел Барташов on 25.06.2022.
//

import UIKit

protocol MainCoordinatorProtocol {
    func start() -> UIViewController
}

final class MainCoordinator {

    //MARK: - Properties

    private let loginInspector = LoginFactoryImp().createLoginInsoector()

    private var feedCoordinator: FeedCoordinator?
    private var loginCoordinator: LoginCoordinator?

    //MARK: - Metods

    func start() -> UIViewController {
        let feedNavigationController = UINavigationController()
        let loginNavigationController = UINavigationController()

        feedCoordinator = FeedCoordinator(navigationController: feedNavigationController)
        loginCoordinator = LoginCoordinator(navigationController: loginNavigationController)

        let feedViewController = ViewControllerFactory.create.feedViewController(tag: 0)
        feedViewController.coordinator = feedCoordinator

        let loginViewController = ViewControllerFactory.create.loginViewController(with: loginInspector, tag: 1)
        loginViewController.coordinator = loginCoordinator

        feedNavigationController.setViewControllers([feedViewController], animated: false)
        loginNavigationController.setViewControllers([loginViewController], animated: false)

        return ViewControllerFactory.create.tabBarController(with: [feedNavigationController, loginNavigationController])
    }
}
