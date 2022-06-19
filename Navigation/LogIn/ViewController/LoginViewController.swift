//
//  LogInViewController.swift
//  Navigation
//
//  Created by Павел Барташов on 20.03.2022.
//

import UIKit

final class LoginViewController: UIViewController {
    //MARK: - Properties
    weak var delegate: LoginViewControllerDelegate?

    //MARK: - Views
    lazy private var loginView: LoginView = {
        let loginView = LoginView()
        loginView.loginButton.addTarget(self,
                                        action:#selector(self.loginButtonClicked),
                                        for: .touchUpInside)
        return loginView
    }()

    private var scrollView = UIScrollView()

    //MARK: - LifeCicle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.isHidden = true

        scrollView.addSubview(loginView)
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

    //MARK: - Metods
    func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        loginView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
    }

    @objc private func kbdShow(notification: NSNotification) {
        if let kbdSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

            let contentInset = UIEdgeInsets(top: 0,
                                            left: 0,
                                            bottom: kbdSize.height - (tabBarController?.tabBar.frame.height ?? 0),
                                            right: 0)

            scrollView.contentInset = contentInset
            scrollView.verticalScrollIndicatorInsets = contentInset

            scrollView.scrollRectToVisible(loginView.loginButton.frame.offsetBy(dx: 0, dy: Constants.padding), animated: true)
        }
    }

    @objc private func kbdHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }

    @objc
    func loginButtonClicked() {
        guard let delegate = delegate else { return }

        if delegate.authPassedFor(login: loginView.login, password: loginView.password) {
            let profileViewController = ViewControllerFactory.create.profileViewController(for: loginView.login)

            navigationController?.pushViewController(profileViewController, animated: true)
        } else {
            loginView.loginButton.transform = CGAffineTransform(translationX: 10, y: 0)
            UIView.animate(withDuration: 0.5, delay: 0,
                           usingSpringWithDamping: 0.1, initialSpringVelocity: 0.1,
                           options: [], animations: {
                self.loginView.loginButton.transform = .identity
            }, completion: nil )
        }
    }
}
