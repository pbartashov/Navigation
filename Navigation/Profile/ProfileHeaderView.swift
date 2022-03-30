//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Павел Барташов on 10.03.2022.
//

import UIKit

final class ProfileHeaderView: UIView {

    let avatarImageView: UIImageView = {
        let image = UIImageView(frame: CGRect(x: Constants.padding,
                                              y: Constants.padding,
                                              width: Constants.avatarImageSize,
                                              height: Constants.avatarImageSize))
        image.layer.borderWidth = 3
        image.layer.cornerRadius = image.frame.width / 2
        image.layer.masksToBounds = true

        return image
    }()

    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black

        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray

        return label
    }()

    let statusTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 15, weight: .regular)
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.placeholder = "Set your status.."

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.rightView = paddingView
        textField.rightViewMode = .always

        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true

        return textField
    }()

    let setStatusButton: UIButton = {
        createButton(withTitle: "Set status")
    }()
       
    override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func initialize() {
        backgroundColor = .systemGray6

        [avatarImageView,
        fullNameLabel,
        statusLabel,
        statusTextField,
        setStatusButton].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        setupLayouts()
    }

    func setup(with profile: Profile) {
        avatarImageView.image = profile.image
        fullNameLabel.text = profile.name
        statusLabel.text = profile.status
    }

    private func setupLayouts() {

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.padding),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
            avatarImageView.widthAnchor.constraint(equalToConstant: Constants.avatarImageSize),
            avatarImageView.heightAnchor.constraint(equalToConstant: Constants.avatarImageSize),

            fullNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            fullNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: Constants.padding),
            fullNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding),

            statusLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: Constants.padding),
            statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding),
            statusLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: -18),

            statusTextField.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: Constants.padding / 2),
            statusTextField.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: Constants.padding),
            statusTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding),
            statusTextField.heightAnchor.constraint(equalToConstant: 40),

            setStatusButton.topAnchor.constraint(equalTo: statusTextField.bottomAnchor, constant: Constants.padding),
            setStatusButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
            setStatusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding),
            setStatusButton.heightAnchor.constraint(equalToConstant: 50),

            bottomAnchor.constraint(equalTo: setStatusButton.bottomAnchor, constant: Constants.padding)
        ])
    }
}
