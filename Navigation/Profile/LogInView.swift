//
//  LogInView.swift
//  Navigation
//
//  Created by Павел Барташов on 20.03.2022.
//

import UIKit

final class LogInView: UIView {

    private let logoImageView = UIImageView(image: UIImage(named: "logo"))

    lazy private var loginTextField: UITextField = {
        let textField = createTextField()

        textField.placeholder = "Email or phone"
        textField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        return textField
    }()

    lazy private var passwordTextField: UITextField = {
        let textField = createTextField()

        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

        return textField
    }()

    let logInButton: UIButton = {
        let button = UIButton()

        button.setTitle("Log in", for: .normal)
        button.setTitleColor(.white, for: .normal)

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

    override init(frame: CGRect) {
        super.init(frame: frame)

        Initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        Initialize()
    }

    func Initialize() {

        [logoImageView,
        loginTextField,
        passwordTextField,
        logInButton].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        setupLayouts()
    }

    func setupLayouts() {
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 120),
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: K.avatarImageSize),
            logoImageView.heightAnchor.constraint(equalToConstant: K.avatarImageSize),

            loginTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
            loginTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.padding),
            loginTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -K.padding),
            loginTextField.heightAnchor.constraint(equalToConstant: 50),

            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.padding),
            passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -K.padding),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),

            logInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: K.padding),
            logInButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.padding),
            logInButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -K.padding),
            logInButton.heightAnchor.constraint(equalToConstant: 50),

            bottomAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: K.padding)
        ])
    }

    private func createTextField() -> UITextField {
        let textField = UITextField()

        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true

        textField.backgroundColor = .systemGray6
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.tintColor = .tintColor
        textField.autocapitalizationType = .none

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.rightView = paddingView
        textField.rightViewMode = .always

        return textField
    }
}
