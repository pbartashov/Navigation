//
//  LogInView.swift
//  Navigation
//
//  Created by Павел Барташов on 20.03.2022.
//

import UIKit

final class LoginView: UIView {

    enum Buttons: String {
        case login = "Log in"
        case brutePassword = "Подобрать пароль"
    }
    
    //MARK: - Properties

    var delegate: ViewWithButtonDelegate?
    private let logoImageView = UIImageView(image: UIImage(named: "logo"))

    var login: String {
        get {
            loginTextField.text ?? ""
        }
        set {
            loginTextField.text = newValue
        }
    }

    var password: String {
        get {
            passwordTextField.text ?? ""
        }
        set {
            passwordTextField.text = newValue
        }
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
        let button = ClosureBasedButton(title: Buttons.login.rawValue,
                                        titleColor: .white,
                                        tapAction: { [weak self] in self?.buttonTapped(sender: $0) })

        let backgroundImage = UIImage(named: "blue_pixel")
        button.setBackgroundImage(backgroundImage, for: .normal)

        let transparentBackgroundImage = UIImage(named: "blue_pixel")?.withAlpha(0.8)
        button.setBackgroundImage(transparentBackgroundImage, for: .selected)
        button.setBackgroundImage(transparentBackgroundImage, for: .highlighted)
        button.setBackgroundImage(transparentBackgroundImage, for: .disabled)

        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true

        button.tag = Buttons.login.hashValue

        return button
    }()

    private lazy var brutePasswordButton: ClosureBasedButton = {
        let button = ClosureBasedButton(title: Buttons.brutePassword.rawValue,
                                        titleColor: .white,
                                        tapAction: { [weak self] in self?.buttonTapped(sender: $0) })

        let backgroundImage = UIImage(named: "blue_pixel")
        button.setBackgroundImage(backgroundImage, for: .normal)

        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true

        button.tag = Buttons.brutePassword.hashValue

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
        loginButton,
        brutePasswordButton].forEach {
            self.addSubview($0)
        }

        setupLayouts()
    }

    private func setupLayouts() {
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(Constants.avatarImageSize)
        }

        loginTextField.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(120)
            make.leading.equalToSuperview().offset(Constants.padding)
            make.trailing.equalToSuperview().offset(-Constants.padding)
            make.height.equalTo(50)
        }

        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(loginTextField.snp.bottom)
            make.leading.trailing.height.equalTo(loginTextField)
        }

        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(Constants.padding)
            make.leading.trailing.height.equalTo(loginTextField)
        }

        brutePasswordButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(Constants.padding)
            make.leading.trailing.height.equalTo(loginTextField)
            make.bottom.equalToSuperview().offset(Constants.padding)
        }
    }

    func buttonTapped(sender: UIButton) {
        delegate?.buttonTapped(sender: sender)
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
