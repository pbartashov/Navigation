//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Павел Барташов on 10.03.2022.
//

import SnapKit

protocol ProfileHeaderViewDelegate: AnyObject {
    func statusButtonTapped()
    func avatarTapped(sender: UIView)
}

final class ProfileHeaderView: UIView {

    //MARK: - Properties

    weak var delegate: ProfileHeaderViewDelegate?

    var statusText: String {
        statusTextField.text ?? ""
    }

    //MARK: - Views

    private lazy var avatarImageView: UIImageView = {
        let image = UIImageView(frame: CGRect(x: Constants.padding,
                                              y: Constants.padding,
                                              width: Constants.avatarImageSize,
                                              height: Constants.avatarImageSize))
        image.layer.borderWidth = 3
        image.layer.cornerRadius = image.frame.width / 2
        image.layer.masksToBounds = true

        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(avatarTapped))
        image.addGestureRecognizer(tapRecognizer)
        image.isUserInteractionEnabled = true

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

    private let statusTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 15, weight: .regular)
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.placeholder = "statusTextFieldPlaceholderProfileHeaderView".localized

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

    private lazy var setStatusButton: ClosureBasedButton = {
        let button = ViewFactory.create.button(withTitle: "setStatusButtonProfileHeaderView".localized)
        button.tapAction =  { [weak self] in self?.setStatusButtonTapped() }
        
        return button
    }()

    //MARK: - LifeCicle

    init(delegate: ProfileHeaderViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)

        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    //MARK: - Metods

    private func initialize() {
        backgroundColor = .systemGray6

        [avatarImageView,
        fullNameLabel,
        statusLabel,
        statusTextField,
        setStatusButton].forEach {
            self.addSubview($0)
        }

        setupLayouts()
    }

    func setup(with user: User?) {
        avatarImageView.image = user?.avatar
        fullNameLabel.text = user?.name
        statusLabel.text = user?.status
    }

    private func setupLayouts() {
        avatarImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Constants.padding)
            make.width.height.equalTo(Constants.avatarImageSize)
        }

        fullNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(27)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(Constants.padding)
            make.trailing.equalToSuperview().offset(-Constants.padding)
        }

        statusLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(Constants.padding)
            make.trailing.equalToSuperview().offset(-Constants.padding)
            make.bottom.equalTo(avatarImageView.snp.bottom).offset(-18)
        }

        statusTextField.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(Constants.padding / 2)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(Constants.padding)
            make.trailing.equalToSuperview().offset(-Constants.padding)
            make.height.equalTo(40)
        }

        setStatusButton.snp.makeConstraints { make in
            make.top.equalTo(statusTextField.snp.bottom).offset(Constants.padding)
            make.leading.equalToSuperview().offset(Constants.padding)
            make.trailing.equalToSuperview().offset(-Constants.padding)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-Constants.padding).priority(999)
        }
    }

    private func setStatusButtonTapped() {
        delegate?.statusButtonTapped()
    }

    @objc private func avatarTapped() {
        delegate?.avatarTapped(sender: avatarImageView)
    }
}
