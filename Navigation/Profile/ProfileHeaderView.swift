//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Павел Барташов on 10.03.2022.
//

import UIKit

final class ProfileHeaderView: UIView {

    private let avatarImageView: UIImageView = {
        let image = UIImageView(frame: CGRect(x: K.padding,
                                              y: K.padding,
                                              width: K.avatarImageSize,
                                              height: K.avatarImageSize))
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
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always

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

        Initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        Initialize()
    }

    func Initialize() {
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

    func setupLayouts() {

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: K.padding),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.padding),
            avatarImageView.widthAnchor.constraint(equalToConstant: K.avatarImageSize),
            avatarImageView.heightAnchor.constraint(equalToConstant: K.avatarImageSize),

            fullNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            fullNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: K.padding),
            fullNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -K.padding),

            statusLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: K.padding),
            statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -K.padding),
            statusLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: -18),

            statusTextField.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: K.padding / 2),
            statusTextField.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: K.padding),
            statusTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -K.padding),
            statusTextField.heightAnchor.constraint(equalToConstant: 40),

            setStatusButton.topAnchor.constraint(equalTo: statusTextField.bottomAnchor, constant: K.padding),
            setStatusButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.padding),
            setStatusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -K.padding),
            setStatusButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
