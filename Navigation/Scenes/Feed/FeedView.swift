//
//  FeedView.swift
//  Navigation
//
//  Created by Павел Барташов on 21.06.2022.
//

import UIKit

final class FeedView: UIStackView {
    enum Buttons: String {
        case post1 = "Post 1"
        case post2 = "Post 2"
        case login = "Log in"
    }

    enum State {
        case wrong
        case right
        case none
    }

    //MARK: - Properties

    var delegate: ViewWithButtonDelegate?

    var text: String {
        passwordTextField.text ?? ""
    }

    var state: State = .none {
        didSet {
            switch state {
                case .wrong:
                    if oldValue == .right {
                        rightAnswerLabel.hideWithAnimation()
                    } else {
                        wrongAnswerLabel.alpha = 0
                    }
                    wrongAnswerLabel.showWithAnimation()

                case .right:
                    if oldValue == .wrong {
                        wrongAnswerLabel.hideWithAnimation()
                    } else {
                        rightAnswerLabel.alpha = 0
                    }
                    rightAnswerLabel.showWithAnimation()

                case .none:
                    rightAnswerLabel.hideWithAnimation()
                    wrongAnswerLabel.hideWithAnimation()
            }
        }
    }

    //MARK: - Views

    private lazy var showPost1Button: ClosureBasedButton = {
        let button = ViewFactory.create.button(withTitle: Buttons.post1.rawValue)
        button.tapActionWithSender = { [weak self] in self?.buttonTapped(sender: $0) }
        button.tag = Buttons.post1.hashValue

        return button
    }()

    private lazy var showPost2Button: ClosureBasedButton = {
        let button = ViewFactory.create.button(withTitle: Buttons.post2.rawValue)
        button.tapActionWithSender = { [weak self] in self?.buttonTapped(sender: $0) }
        button.tag = Buttons.post2.hashValue

        return button
    }()

    private let wrongAnswerLabel: UILabel = {
        let label = UILabel()
        label.text = "Wrong"
        label.alpha = 0
        label.textColor = .red
        label.textAlignment = .center
        return label
    }()

    private let rightAnswerLabel: UILabel = {
        let label = UILabel()
        label.text = "Right"
        label.alpha = 0
        label.textColor = .green
        label.textAlignment = .center
        return label
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = ViewFactory.create.textField()

        textField.placeholder = "Password"

        return textField
    }()

    private lazy var loginButton: ClosureBasedButton = {
        let button =  ViewFactory.create.button(withTitle: Buttons.login.rawValue)
        button.tapActionWithSender = { [weak self] in self?.buttonTapped(sender: $0) }
        button.tag = Buttons.login.hashValue

        return button
    }()

    //MARK: - LifeCicle
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

    convenience init(delegate: ViewWithButtonDelegate) {
        self.init(frame: .zero)
        self.delegate = delegate
    }

    //MARK: - Metods

    private func initialize() {
        self.axis = .vertical
        self.spacing = 24

        let answerContainer = UIView()

        [showPost1Button,
         showPost2Button,
         passwordTextField,
         answerContainer,
         loginButton].forEach {
            self.addArrangedSubview($0)
        }

        answerContainer.addSubview(wrongAnswerLabel)
        answerContainer.addSubview(rightAnswerLabel)

        wrongAnswerLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        rightAnswerLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func buttonTapped(sender: UIButton) {
        delegate?.buttonTapped(sender: sender)
    }
}
