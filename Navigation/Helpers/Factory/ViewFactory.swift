//
//  ComponentFactory.swift
//  Navigation
//
//  Created by Павел Барташов on 15.06.2022.
//

import UIKit

struct ViewFactory {

    // MARK: - Properties

    static var create = ViewFactory()

    // MARK: - Metods

    func button(withTitle title: String) -> ClosureBasedButton {
        let button = ClosureBasedButton(title: title,
                                        titleColor: .lightTextColor,
                                        backgroundColor: .systemBlue)

        button.layer.cornerRadius = 14

        button.layer.shadowOffset = .init(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.shadowColor.cgColor
        button.layer.shadowOpacity = 0.7

        return button
    }

    func button<ButtonType: Hashable>(imageSystemNameForNormal: String,
                                      imageSystemNameForSelected: String? = nil,
                                      buttonType: ButtonType,
                                      buttonImageColor: UIColor? = nil,
                                      buttonSize: CGFloat,
                                      delegate: ViewWithButtonDelegate?
    ) -> UIButton {
        let config = UIImage.SymbolConfiguration(pointSize: buttonSize)
        var image = UIImage(systemName: imageSystemNameForNormal, withConfiguration: config)

        let button = ShadowOnTapButton(image: image?.withTintColor(buttonImageColor),
                                       tapAction: { [weak delegate] in delegate?.buttonTapped(sender: $0) })
        button.tag = buttonType.hashValue

        if let imageSystemNameForSelected = imageSystemNameForSelected {
            image = UIImage(systemName: imageSystemNameForSelected, withConfiguration: config)
            button.setImage(image?.withTintColor(buttonImageColor), for: .selected)
        }

        return button
    }

    func button(title: String,
                tag: Int,
                tapAction: ((UIButton) -> Void)?
    ) -> ClosureBasedButton {
        let button = ClosureBasedButton(title: title,
                                        titleColor: .white,
                                        tapAction: tapAction)
        button.setTitleColor(.lightTextColor, for: .normal)

        let backgroundImage = UIImage(named: "blue_pixel")
        button.setBackgroundImage(backgroundImage, for: .normal)

        let transparentBackgroundImage = UIImage(named: "blue_pixel")?.withAlpha(0.8)
        button.setBackgroundImage(transparentBackgroundImage, for: .selected)
        button.setBackgroundImage(transparentBackgroundImage, for: .highlighted)
        button.setBackgroundImage(transparentBackgroundImage, for: .disabled)

        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true

        button.tag = tag

        return button
    }

    func textField() -> UITextField {
        let textField = UITextField()

        textField.layer.borderColor = UIColor.borderColor.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true

        textField.backgroundColor = .backgroundColor
        textField.textColor = .textColor
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.autocapitalizationType = .none

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.rightView = paddingView
        textField.rightViewMode = .always

        return textField
    }
}
