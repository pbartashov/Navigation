//
//  ViewWithButtonDelegate.swift
//  Navigation
//
//  Created by Павел Барташов on 21.06.2022.
//

import UIKit

protocol ViewWithButtonDelegate: AnyObject {
    func buttonTapped()
    func buttonTapped(sender: UIButton)
}

extension ViewWithButtonDelegate {
    func buttonTapped() {}
    func buttonTapped(sender: UIButton) {}
}

