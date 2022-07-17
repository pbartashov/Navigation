//
//  UIButton+Extension.swift
//  Navigation
//
//  Created by Павел Барташов on 17.07.2022.
//

import UIKit

extension UIButton {
    func select() {
        isSelected = true
    }

    func deSelect() {
        isSelected = false
    }

    func enable() {
        isEnabled = true
    }

    func disable() {
        isEnabled = false
    }
}
