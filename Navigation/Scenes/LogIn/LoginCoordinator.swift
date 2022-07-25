//
//  LiginCoordinator.swift
//  Navigation
//
//  Created by Павел Барташов on 25.06.2022.
//

import UIKit

final class LoginCoordinator: NavigationCoordinator {

    //MARK: - Properties

    private let profileCoordinator: ProfileCoordinator
    private let hintCoordinator: NavigationCoordinator

    //MARK: - LifeCicle

    override init(navigationController: UINavigationController) {
        self.profileCoordinator = ProfileCoordinator(navigationController: navigationController)
        self.hintCoordinator = NavigationCoordinator(navigationController: navigationController)
        super.init(navigationController: navigationController)
    }

    //MARK: - Metods

    func showProfile(for userName: String) {
        let profileViewModel = ProfileFactory.create.viewModelWith(coordinator: profileCoordinator,
                                                                   userName: userName)

        let profileViewController = ProfileFactory.create.viewControllerWith(viewModel: profileViewModel)
        
        navigationController?.pushViewController(profileViewController, animated: true)
    }

    func startHintTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let hintViewModel = HintViewModel(coordinator: self.hintCoordinator)
            let hintViewController = HintViewController(viewModel: hintViewModel)
            //            hintViewController.modalPresentationStyle = .overFullScreen

            self.navigationController?.present(hintViewController, animated: true)
        }
    }
}
