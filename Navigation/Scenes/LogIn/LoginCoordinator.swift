//
//  LiginCoordinator.swift
//  Navigation
//
//  Created by Павел Барташов on 25.06.2022.
//

import UIKit

protocol LoginCoordinatorProtocol: AnyObject {
    func showMainScene(for userName: String)
    func startHintTimer()
    func showCreateAccount(for login: String,
                           completion: (()-> Void)?)
    func showNeedBiometricAccess()
    func showEnrollBiometric()
}

final class LoginCoordinator: NavigationCoordinator, LoginCoordinatorProtocol {

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

        let alert = UIAlertController(title: "createAccountPromptTitleLoginCoordinator".localized,
                                      message: "\("createAccountPromptMessageLoginCoordinator".localized) \(login)?",
                                      preferredStyle: .alert)

        let yes = UIAlertAction(title: "yesAnswerLoginCoordinator".localized,
                                style: .default,
                                handler: { _ in completion?() })
        let no = UIAlertAction(title: "noAnswerLoginCoordinator".localized,
                               style: .cancel)
        alert.addAction(yes)
        alert.addAction(no)

        navigationController?.present(alert, animated: true)
    }

    func showNeedBiometricAccess() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            showGoTo(url: url, title: "needBiometricAccessLoginCoordinator".localized)
        }
    }

    func showEnrollBiometric() {
        if let url = URL(string: "App-Prefs:root=TOUCHID_PASSCODE") {
            showGoTo(url: url, title: "enrollBiometricsLoginCoordinator".localized)
        }
    }

    private func showGoTo(url: URL, title: String) {
        let alert = UIAlertController(title: title,
                                      message: nil,
                                      preferredStyle: .alert)

        let setting = UIAlertAction(title: "settingsLoginCoordinator".localized,
                                    style: .default) { _ in
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }

        let ok = UIAlertAction(title: "cancelLoginCoordinator".localized,
                               style: .default)
        [setting, ok].forEach {
            alert.addAction($0)
        }

        navigationController?.present(alert, animated: true)
    }
}
