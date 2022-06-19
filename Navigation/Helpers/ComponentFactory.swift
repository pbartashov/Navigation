//
//  ComponentFactory.swift
//  Navigation
//
//  Created by Павел Барташов on 15.06.2022.
//

import UIKit

final class ComponentFactory {
    static func createButton(withTitle title: String) -> UIButton {
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
}


