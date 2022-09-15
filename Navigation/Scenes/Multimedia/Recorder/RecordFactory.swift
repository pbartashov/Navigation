//
//  RecordFactory.swift
//  Navigation
//
//  Created by Павел Барташов on 17.07.2022.
//

import UIKit

struct RecordFactory {
    private enum Constants {
        static let buttonSize: CGFloat = 60
    }

    func createButton(imageSystemNameForNormal: String,
                      imageSystemNameForSelected: String? = nil,
                      buttonType: RecorderView.Buttons,
                      buttonImageColor: UIColor? = nil,
                      delegate: ViewWithButtonDelegate?
    ) -> UIButton {
        ViewFactory.create.button(imageSystemNameForNormal: imageSystemNameForNormal,
                                  imageSystemNameForSelected: imageSystemNameForSelected,
                                  buttonType: buttonType,
                                  buttonImageColor: buttonImageColor,
                                  buttonSize: Constants.buttonSize,
                                  delegate: delegate)
    }
}
