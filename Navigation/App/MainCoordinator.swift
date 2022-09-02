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
    
    private let window: UIWindow

    private let loginInspector = LoginInspectorFactoryImp().createLoginInspector()

    private var feedCoordinator: FeedCoordinator?
    private var loginCoordinator: LoginCoordinator?
    private var profileCoordinator: ProfileCoordinator?

    // MARK: - LifeCicle

    init(window: UIWindow) {
        self.window = window
    }

    //MARK: - Metods

    func start() -> UIViewController {
        let loginNavigationController = UINavigationController()

        let loginCoordinator = LoginCoordinator(navigationController: loginNavigationController) { [weak self] userName in
            self?.switchToMainViewController(for: userName)
        }
        self.loginCoordinator = loginCoordinator

        let loginViewController = ViewControllerFactory.create.loginViewController(loginDelegate: loginInspector,
                                                                                   coordinator: loginCoordinator,
                                                                                   tag: 0)

        loginNavigationController.setViewControllers([loginViewController], animated: false)

        ErrorPresenter.shared.initialize(with: loginViewController)

        return loginNavigationController
    }

    private func createMainViewController(for userName: String) -> UIViewController {
        let feedNavigationController = UINavigationController()
        feedCoordinator = FeedCoordinator(navigationController: feedNavigationController)

        let feedViewController = ViewControllerFactory.create.feedViewController(tag: 0)
        feedViewController.coordinator = feedCoordinator
        feedNavigationController.setViewControllers([feedViewController], animated: false)

        let profileNavigationController = UINavigationController()
        profileCoordinator = ProfileCoordinator(navigationController: profileNavigationController)

        let profileViewController = ViewControllerFactory.create.profileViewController(userName: userName,
                                                                                       coordinator: profileCoordinator,
                                                                                       tag: 1)
        profileNavigationController.setViewControllers([profileViewController], animated: false)

        let favoritesViewController = ViewControllerFactory.create.favoritesViewController(tag: 2)


        let tabBarController = ViewControllerFactory.create.tabBarController(with: [
            feedNavigationController,
            profileNavigationController,
            favoritesViewController
        ])

        tabBarController.selectedIndex = 1

        ErrorPresenter.shared.initialize(with: tabBarController)

        return tabBarController
    }

    func switchTo(viewController: UIViewController) {

        window.rootViewController = viewController

        // add animation
        UIView.transition(with: window,
                          duration: 0.5,
                          options: [.transitionFlipFromLeft],
                          animations: nil,
                          completion: nil)
    }

    func switchToMainViewController(for userName: String) {
        let viewController = createMainViewController(for: userName)
        switchTo(viewController: viewController)
    }
}
