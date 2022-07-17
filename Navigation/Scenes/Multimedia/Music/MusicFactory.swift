//
//  MusicFactory.swift
//  Navigation
//
//  Created by Павел Барташов on 17.07.2022.
//

import UIKit

struct MusicFactory {
    private enum Constants {
        static let buttonSize: CGFloat = 30
    }

    func createButton(imageSystemNameForNormal: String,
                      buttonType: MusicView.Buttons,
                      buttonImageColor: UIColor? = nil,
                      delegate: ViewWithButtonDelegate?
    ) -> UIButton {
        ViewFactory.create.button(imageSystemNameForNormal: imageSystemNameForNormal,
                                  buttonType: buttonType,
                                  buttonImageColor: buttonImageColor,
                                  buttonSize: Constants.buttonSize,
                                  delegate: delegate)
    }
}
