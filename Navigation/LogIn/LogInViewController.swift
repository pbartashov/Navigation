//
//  LogInViewController.swift
//  Navigation
//
//  Created by Павел Барташов on 20.03.2022.
//

import UIKit

final class LogInViewController: UIViewController {

    lazy private var logInView: LogInView = {
        let logInView = LogInView()
        logInView.logInButton.addTarget(self,
                                        action:#selector(self.logInButtonClicked),
                                        for: .touchUpInside)
        return logInView
    }()

    private var scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.isHidden = true

        scrollView.addSubview(logInView)
        view.addSubview(scrollView)

        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // подписаться на уведомления
        let nc = NotificationCenter.default

        nc.addObserver(self,
                       selector: #selector(kbdShow),
                       name: UIResponder.keyboardWillShowNotification,
                       object: nil)

        nc.addObserver(self,
                       selector: #selector(kbdHide),
                       name: UIResponder.keyboardWillHideNotification,
                       object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        // отписаться от уведомлений
        let nc = NotificationCenter.default

        nc.removeObserver(self,
                          name: UIResponder.keyboardWillShowNotification,
                          object: nil)

        nc.removeObserver(self,
                          name: UIResponder.keyboardWillHideNotification,
                          object: nil)
    }

    func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        logInView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            logInView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            logInView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            logInView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            logInView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            logInView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    @objc private func kbdShow(notification: NSNotification) {
        if let kbdSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

            let contentInset = UIEdgeInsets(top: 0,
                                            left: 0,
                                            bottom: kbdSize.height - (tabBarController?.tabBar.frame.height ?? 0),
                                            right: 0)

            scrollView.contentInset = contentInset
            scrollView.verticalScrollIndicatorInsets = contentInset

            scrollView.scrollRectToVisible(logInView.logInButton.frame.offsetBy(dx: 0, dy: Constants.padding), animated: true)
        }
    }

    @objc private func kbdHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }

    @objc
    func logInButtonClicked() {
#if DEBUG
        let userService = TestUserService()
#else
        let user = User(name: "Octopus",
                        avatar: (UIImage(named: "profileImage") ?? UIImage(systemName: "person"))!,
                        status: "Hardly coding")
        let userService = CurrentUserService(currentUser: user)
#endif
        let profileViewController = ProfileViewController(userService: userService, userName: logInView.login)
        
        navigationController?.pushViewController(profileViewController, animated: true)
    }
}
