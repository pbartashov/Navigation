//
//  MainTabBarController.swift
//  Navigation
//
//  Created by Павел Барташов on 25.06.2022.
//

import UIKit

class MainTabBarController: UITabBarController {

    //MARK: - Properties

    private let loginInspector = LoginFactoryImp().createLoginInsoector()
    private let mainCoordinator = MainCoordinator()

    //MARK: - LifeCicle

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.backgroundColor = .systemGray6

        setControllers()
    }

    //MARK: - Metods

    private func setControllers() {
        viewControllers = [
            ViewControllerFactory.create.feedViewController(tag: 0),
            ViewControllerFactory.create.loginViewController(with: loginInspector, tag: 1)
        ]
    }
}
