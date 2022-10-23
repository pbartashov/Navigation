//
//  HintView.swift
//  Navigation
//
//  Created by Павел Барташов on 06.07.2022.
//

import UIKit

final class HintView: UIStackView {

    enum Buttons {
        case close
        case previous
        case next

        var title: String {
            switch self {
                case .close:
                    return "closeButtonHintView".localized

                default:
                    return ""
            }
        }
    }

    //MARK: - Properties

    private lazy var timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional // Use the appropriate positioning for the current locale
        formatter.allowedUnits = [  .minute, .second ] // Units to display in the formatted string
        formatter.zeroFormattingBehavior = [ .pad ] // Pad with zeroes where appropriate for the locale

        return formatter
    }()

    var delegate: ViewWithButtonDelegate?

    //MARK: - Views

    private let logoImageView: UIImageView =  {
        let config = UIImage.SymbolConfiguration(pointSize: 72)
        let image = UIImage(systemName: "clock", withConfiguration: config)
        let imageView = UIImageView(image: image)

        return imageView
    }()

    private lazy var countDownLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 56)
        label.textAlignment = .center

        return label
    }()

    private lazy var closeButton: ClosureBasedButton = {
        let button = ClosureBasedButton(title: Buttons.close.title,
                                        titleColor: .tintColor,
                                        tapAction: { [weak self] in self?.buttonTapped(sender: $0) })
        button.tag = Buttons.close.hashValue

        return button
    }()

    private lazy var hintLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }()

    private lazy var cover: UIView = { // BLUR
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)

        return blurEffectView
    }()

    private lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 2 * Constants.padding

        return stack
    }()

    private lazy var previousButton: ClosureBasedButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "chevron.backward", withConfiguration: config)
        let button = ClosureBasedButton(image: image,
                                        tapAction: { [weak self] in self?.buttonTapped(sender: $0) })
        button.tag = Buttons.previous.hashValue

        return button
    }()

    private lazy var nextButton: ClosureBasedButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "chevron.forward", withConfiguration: config)
        let button = ClosureBasedButton(image: image,
                                        tapAction: { [weak self] in self?.buttonTapped(sender: $0) })
        button.tag = Buttons.next.hashValue

        return button
    }()

    //MARK: - LifeCicle

    override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Metods

    private func initialize() {
        addSubviews(cover,
                    mainStack)

        let buttonStack = UIStackView()
        buttonStack.spacing = 36
        buttonStack.alignment = .center

        [previousButton,
         closeButton,
         nextButton
        ].forEach {
            buttonStack.addArrangedSubview($0)
        }

        [logoImageView,
         countDownLabel,
         hintLabel,
         buttonStack
        ].forEach {
            self.mainStack.addArrangedSubview($0)
        }

        setupLayouts()
    }

    private func setupLayouts() {
        cover.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        mainStack.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(Constants.padding)
            make.trailing.equalToSuperview().offset(-Constants.padding)
        }

        logoImageView.snp.makeConstraints { make in
            make.height.equalTo(logoImageView.snp.width)
        }
    }

    private func buttonTapped(sender: UIButton) {
        delegate?.buttonTapped(sender: sender)
    }

    func updateProgress(with seconds: TimeInterval) {
        countDownLabel.text = timeFormatter.string(from: seconds)
    }

    func updateHint(with hint: String) {
        UIView.animate(withDuration: 0.5) {
            self.hintLabel.isHidden = true
        }

        hintLabel.text = hint
        
        UIView.animate(withDuration: 0.5) {
            self.hintLabel.isHidden = false
        }
    }

    func updateButtons(with position: CollectionPosition) {
        switch position {
            case .first:
                previousButton.hideWithAnimation()
                nextButton.showWithAnimation()

            case .middle:
                previousButton.showWithAnimation()
                nextButton.showWithAnimation()

            case .last:
                previousButton.showWithAnimation()
                nextButton.hideWithAnimation()
        }
    }
}
