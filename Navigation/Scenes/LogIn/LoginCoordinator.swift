//
//  LiginCoordinator.swift
//  Navigation
//
//  Created by Павел Барташов on 25.06.2022.
//

import UIKit

final class LoginCoordinator: NavigationCoordinator {

    //MARK: - Properties

    private let hintCoordinator: NavigationCoordinator
    private let switchToMainScene: (String) -> Void

    //MARK: - LifeCicle

    init(navigationController: UINavigationController,
         switchToMainScene: @escaping (String) -> Void) {

        self.hintCoordinator = NavigationCoordinator(navigationController: navigationController)
        self.switchToMainScene = switchToMainScene
        super.init(navigationController: navigationController)
        self.navigationController = navigationController
    }

    //MARK: - Metods

    func showMainScene(for userName: String) {
        switchToMainScene(userName)
    }

    func startHintTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            let hintViewModel = HintViewModel(coordinator: self.hintCoordinator)
            let hintViewController = HintViewController(viewModel: hintViewModel)
            //            hintViewController.modalPresentationStyle = .overFullScreen

            self.navigationController?.present(hintViewController, animated: true)
        }
    }

    func showCreateAccount(for login: String,
                           completion: (()-> Void)? = nil) {

        let alert = UIAlertController(title: "Создать аккаунт?",
                                      message: "Вы хотите создать аккаунт для пользователя \(login)?",
                                      preferredStyle: .alert)

        let yes = UIAlertAction(title: "Да",
                                style: .default,
                                handler: { _ in completion?() })
        let no = UIAlertAction(title: "Нет",
                               style: .cancel)
        alert.addAction(yes)
        alert.addAction(no)

        navigationController?.present(alert, animated: true)
    }
}
