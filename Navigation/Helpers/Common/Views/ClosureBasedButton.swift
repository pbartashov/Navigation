//
//  ClosureBasedButton.swift
//  Navigation
//
//  Created by Павел Барташов on 20.06.2022.
//

import UIKit

class ClosureBasedButton: UIButton {

    var tapAction: (() -> Void)? {
        didSet {
            if tapAction == nil {
                removeTarget(self, action: #selector(self.tap), for: .touchDragEnter)
            } else {
                addTarget(self, action: #selector(self.tap), for: .touchUpInside)
            }
        }
    }

    var tapActionWithSender: ((_ sender: UIButton) -> Void)? {
        didSet {
            if tapActionWithSender == nil {
                removeTarget(self, action: #selector(self.tapWithSender), for: .touchDragEnter)
            } else {
                addTarget(self, action: #selector(self.tapWithSender), for: .touchUpInside)
            }
        }
    }

    init(title: String? = nil,
         titleColor: UIColor? = nil,
         backgroundColor: UIColor? = nil,
         image: UIImage? = nil
    ) {
        super.init(frame: .zero)

        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)

        setImage(image, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func tap() {
        tapAction?()
    }

    @objc private func tapWithSender() {
        tapActionWithSender?(self)
    }
}

extension ClosureBasedButton {
    convenience init(title: String? = nil,
                     titleColor: UIColor? = nil,
                     backgroundColor: UIColor? = nil,
                     image: UIImage? = nil,
                     tapAction: (() -> Void)? = nil) {

        self.init(title: title, titleColor: titleColor, backgroundColor: backgroundColor, image: image)

        defer { // need to trigger didSet
            self.tapAction = tapAction
        }
    }

    convenience init(title: String? = nil,
                     titleColor: UIColor? = nil,
                     backgroundColor: UIColor? = nil,
                     image: UIImage? = nil,
                     tapAction: ((_ sender: UIButton) -> Void)? = nil) {

        self.init(title: title, titleColor: titleColor, backgroundColor: backgroundColor, image: image)

        defer { // need to trigger didSet
            self.tapActionWithSender = tapAction
        }
    }
}
