//
//  Coordinator.swift
//  Navigation
//
//  Created by Павел Барташов on 09.07.2022.
//

import UIKit

class NavigationCoordinator {

    //MARK: - Properties

    weak var navigationController: UINavigationController?

    //MARK: - LifeCicle

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    //MARK: - Metods

    func pop(animated: Bool) {
        navigationController?.popViewController(animated: animated)
    }

    func dismiss(animated: Bool) {
        navigationController?.dismiss(animated: animated)
    }
}

