//
//  ComponentFactory.swift
//  Navigation
//
//  Created by Павел Барташов on 15.06.2022.
//

import UIKit

struct ViewFactory {
    static var create = ViewFactory()

    func button(withTitle title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue

        button.layer.cornerRadius = 14

        button.layer.shadowOffset = .init(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7

        return button
    }

    func textField() -> UITextField {
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


