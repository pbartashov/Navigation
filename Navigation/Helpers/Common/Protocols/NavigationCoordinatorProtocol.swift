//
//  NavigationCoordinatorProtocol.swift
//  Navigation
//
//  Created by Павел Барташов on 25.06.2022.
//

import UIKit

protocol NavigationCoordinatorProtocol {
    var navigationController: UINavigationController? { get set }
}

class NavigationCoordinator {
    //MARK: - Properties

    weak var navigationController: UINavigationController?

    //MARK: - LifeCicle

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
