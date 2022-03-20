//
//  Helper.swift
//  Navigation
//
//  Created by Павел Барташов on 13.03.2022.
//

import UIKit

func createButton(withTitle title: String) -> UIButton {

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

extension UIImage {
    func withAlpha(_ a: CGFloat) -> UIImage {
        return UIGraphicsImageRenderer(size: size, format: imageRendererFormat).image { (_) in
            draw(in: CGRect(origin: .zero, size: size), blendMode: .normal, alpha: a)
        }
    }
}
