//
//  UIColor+Extension.swift
//  Navigation
//
//  Created by Павел Барташов on 24.10.2022.
//

import UIKit

extension UIColor {
    static func makeColor(lightMode: UIColor, darkMode: UIColor) -> UIColor {
        guard #available(iOS  13.0, *) else {
            return lightMode
        }

        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .light ? lightMode : darkMode
        }
    }
}

extension UIColor {
    static var backgroundColor: UIColor {
        Self.makeColor(lightMode: .systemGray6, darkMode: .black)
    }

    static var lightBackgroundColor: UIColor {
        Self.makeColor(lightMode: .white, darkMode: .darkGray)
    }

    static var borderColor: UIColor {
        Self.makeColor(lightMode: .lightGray, darkMode: .lightGray)
    }

    static var shadowColor: UIColor {
        Self.makeColor(lightMode: .black, darkMode: .darkGray)
    }

    static var textColor: UIColor {
        Self.makeColor(lightMode: .black, darkMode: .white)
    }

    static var secondaryTextColor: UIColor {
        Self.makeColor(lightMode: .gray, darkMode: .lightGray)
    }

    static var lightTextColor: UIColor {
        Self.makeColor(lightMode: .white, darkMode: .lightGray)
    }

    static var placeholderTextColor: UIColor {
        Self.makeColor(lightMode: .gray, darkMode: .lightGray)
    }
}
