//
//  LogInViewController.swift
//  Navigation
//
//  Created by Павел Барташов on 20.03.2022.
//

import UIKit


final class LoginViewController<ViewModelType: LoginViewModelProtocol> : UIViewController {

    //MARK: - Properties

    private var viewModel: ViewModelType

    //MARK: - Views

    private lazy var loginView: LoginView = {
        let loginView = LoginView()
        loginView.delegate = self
        
        return loginView
    }()

    private let scrollView = UIScrollView()

    //MARK: - LifeCicle

    init(viewModel: ViewModelType) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.isHidden = true

        scrollView.addSubview(loginView)
        view.addSubview(scrollView)

        setupLayout()

        setupViewModel()
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

    private func setupViewModel() {
        viewModel.stateChanged = { [weak self] state in
            switch state {
                case .initial:
                    break
                case .authFailed:
                    DispatchQueue.main.async {
                        self?.loginView.shakeLoginButton()
                    }
            }
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

            scrollView.scrollRectToVisible(loginView.loginButtonFrame.offsetBy(dx: 0, dy: Constants.padding),
                                           animated: true)
        }
    }

    @objc private func kbdHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
}

// MARK: - ViewWithButtonDelegate methods
extension LoginViewController: ViewWithButtonDelegate {
    func buttonTapped(sender: UIButton) {
        switch sender.tag {
            case LoginView.Buttons.login.hashValue:
                viewModel.perfomAction(.authWith(login: loginView.login, password: loginView.password))

            case LoginView.Buttons.brutePassword.hashValue:
                let randomPassword = getRandomString(length: 3)

                let bruteWorkItem = DispatchWorkItem {
                    BruteForce().bruteForce(passwordToUnlock: randomPassword)
                }

                bruteWorkItem.notify(queue: DispatchQueue.main) {
                    print()
                }

                DispatchQueue.global().async(execute: bruteWorkItem)

            default:
                break
        }
    }
}
