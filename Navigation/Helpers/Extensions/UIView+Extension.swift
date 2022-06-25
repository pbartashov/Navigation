//
//  UIView+Extension.swift
//  Navigation
//
//  Created by Павел Барташов on 25.03.2022.
//

import UIKit

public extension UIView {
    static var identifier: String {
        String(describing: self)
    }

    func addSubviewsToAutoLayout(_ subviews: UIView...) {
        subviews.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func hideWithAnimation() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.alpha = 0
        }
    }

    func showWithAnimation() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.alpha = 1
        }
    }
}
