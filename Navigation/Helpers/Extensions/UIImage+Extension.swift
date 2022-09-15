//
//  UIImage+Extension.swift
//  Navigation
//
//  Created by Павел Барташов on 25.03.2022.
//

import UIKit

extension UIImage {
    static let placeholder = UIImage(systemName: "photo")

    func withAlpha(_ a: CGFloat) -> UIImage {
        return UIGraphicsImageRenderer(size: size, format: imageRendererFormat).image { (_) in
            draw(in: CGRect(origin: .zero, size: size), blendMode: .normal, alpha: a)
        }
    }

    func withTintColor(_ color: UIColor?) -> UIImage {
        if let color = color {
            return withTintColor(color, renderingMode: .alwaysOriginal)
        }
        return self
    }
}
