//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Павел Барташов on 10.03.2022.
//

import UIKit

final class ProfileHeaderView: UIView {

    private let image: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 16,
                                              y: 16,
                                              width: 100,
                                              height: 100))
        image.layer.borderWidth = 3
        image.layer.cornerRadius = image.frame.width / 2
        image.layer.masksToBounds = true

        return image
    }()

    private let name: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black

        return label
    }()

    private let status: UILabel = {
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

    let buttonSetStatus: UIButton = {
        let button = UIButton()
        button.setTitle("Set status", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 14

        button.layer.shadowOffset = .init(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7

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
        addSubview(image)
        addSubview(name)
        addSubview(status)
        addSubview(statusTextField)
        addSubview(buttonSetStatus)

        setViewFrames()
    }

    func setup(with profile: Profile) {
        image.image = profile.image
        name.text = profile.name
        status.text = profile.status
    }

    func setViewFrames() {

        let safeArea = frame.inset(by: safeAreaInsets)
        let container = CGRect(origin: CGPoint(x: safeAreaInsets.left + 16,
                                               y: safeAreaInsets.top + 16),
                               size: CGSize(width: safeArea.width - 16 - 16,
                                            height: 27 + 22 + 31 + 18 + 8 + 16 + 40 + 50))

        image.frame.origin = container.origin

        let labelWidth = container.width - image.frame.width - 16

        name.frame = CGRect(x: image.frame.maxX + 16,
                            y: safeAreaInsets.top + 27,
                            width: labelWidth,
                            height: 22)

        status.frame = CGRect(x: image.frame.maxX + 16,
                              y: name.frame.maxY + 31,
                              width: labelWidth,
                              height: 18)

        statusTextField.frame = CGRect(x: image.frame.maxX + 16,
                                       y: status.frame.maxY + 8,
                                       width: labelWidth,
                                       height: 40)

        buttonSetStatus.frame = CGRect(x: container.minX,
                                        y: statusTextField.frame.maxY + 16,
                                        width: container.width,
                                        height: 50)
    }
}
