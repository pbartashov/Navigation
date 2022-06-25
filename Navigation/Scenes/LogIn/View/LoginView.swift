//
//  LogInView.swift
//  Navigation
//
//  Created by Павел Барташов on 20.03.2022.
//

import UIKit

final class LoginView: UIView {

    //MARK: - Properties

    var delegate: ViewWithButtonDelegate?
    private let logoImageView = UIImageView(image: UIImage(named: "logo"))

    var login: String {
        loginTextField.text ?? ""
    }

    var password: String {
        passwordTextField.text ?? ""
    }

    var loginButtonFrame: CGRect {
        loginButton.frame
    }
    
    //MARK: - Views

    private lazy var loginTextField: UITextField = {
        let textField = ViewFactory.create.textField()

        textField.placeholder = "Email or phone"
        textField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = ViewFactory.create.textField()

        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

        return textField
    }()

    private lazy var loginButton: ClosureBasedButton = {
        let button = ClosureBasedButton(title: "Log in",
                                        titleColor: .white,
                                        tapAction: { [weak self] in self?.loginButtonTapped() })

        let backgroundImage = UIImage(named: "blue_pixel")
        button.setBackgroundImage(backgroundImage, for: .normal)

        let transparentBackgroundImage = UIImage(named: "blue_pixel")?.withAlpha(0.8)
        button.setBackgroundImage(transparentBackgroundImage, for: .selected)
        button.setBackgroundImage(transparentBackgroundImage, for: .highlighted)
        button.setBackgroundImage(transparentBackgroundImage, for: .disabled)

        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true

        return button
    }()

    //MARK: - LifeCicle
    override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()

        //DEBUGG
        loginTextField.text = "Octopus"
        passwordTextField.text = "123"
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    //MARK: - Metods
    
    private func initialize() {
        [logoImageView,
        loginTextField,
        passwordTextField,
        loginButton].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        setupLayouts()
    }

    private func setupLayouts() {
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 120),
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: Constants.avatarImageSize),
            logoImageView.heightAnchor.constraint(equalToConstant: Constants.avatarImageSize),

            loginTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
            loginTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
            loginTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding),
            loginTextField.heightAnchor.constraint(equalToConstant: 50),

            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
            passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),

            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: Constants.padding),
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
            loginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding),
            loginButton.heightAnchor.constraint(equalToConstant: 50),

            bottomAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: Constants.padding)
        ])
    }

    func loginButtonTapped() {
        delegate?.buttonTapped()
    }

    func shakeLoginButton() {
        loginButton.transform = CGAffineTransform(translationX: 10, y: 0)

        UIView.animate(withDuration: 0.5, delay: 0,
                       usingSpringWithDamping: 0.1, initialSpringVelocity: 0.1,
                       options: [], animations: {
            self.loginButton.transform = .identity
        }, completion: nil )
    }
}
