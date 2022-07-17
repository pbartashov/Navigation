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

final class MainCoordinator: MainCoordinatorProtocol {

    //MARK: - Properties

    private let loginInspector = LoginInspectorFactoryImp().createLoginInspector()

    private var feedCoordinator: FeedCoordinator?
    private var loginCoordinator: LoginCoordinator?

    //MARK: - Metods

    func start() -> UIViewController {
        let feedNavigationController = UINavigationController()
        let loginNavigationController = UINavigationController()

        feedCoordinator = FeedCoordinator(navigationController: feedNavigationController)
        let loginCoordinator = LoginCoordinator(navigationController: loginNavigationController)
        self.loginCoordinator = loginCoordinator

        let feedViewController = ViewControllerFactory.create.feedViewController(tag: 0)
        feedViewController.coordinator = feedCoordinator

        let musicViewController = ViewControllerFactory.create.musicViewController(tag: 1)

        let videoViewController = ViewControllerFactory.create.videoViewController(tag: 2)

        let recorderViewController = ViewControllerFactory.create.recorderViewController(tag: 3)

        let loginViewController = ViewControllerFactory.create.loginViewController(loginDelegate: loginInspector,
                                                                                   coordinator: loginCoordinator,
                                                                                   tag: 4)

        feedNavigationController.setViewControllers([feedViewController], animated: false)
        loginNavigationController.setViewControllers([loginViewController], animated: false)

        let tabBarController = ViewControllerFactory.create.tabBarController(with: [
            feedNavigationController,
            musicViewController,
            videoViewController,
            recorderViewController,
            loginNavigationController
        ])
        
        ErrorPresenter.shared.initialize(with: tabBarController)

        return tabBarController
    }
}
