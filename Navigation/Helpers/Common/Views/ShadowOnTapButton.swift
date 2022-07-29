//
//  ShadowOnTapButton.swift
//  Navigation
//
//  Created by Павел Барташов on 19.07.2022.
//

import UIKit

final class ShadowOnTapButton: ClosureBasedButton {

    // MARK: - Properties

    var shadowOpacity: Float = 0.3
    var imageViewDownScale: CGFloat = 0.8
    var shadowUpScale: CGFloat = 1.5

    private lazy var shadowLayer: CALayer = {
        $0.backgroundColor = UIColor.lightGray.cgColor
        $0.opacity = 0.0

        return $0
    }(CALayer())

    // MARK: - LifeCicle

    override init(title: String? = nil,
                  titleColor: UIColor? = nil,
                  backgroundColor: UIColor? = nil,
                  image: UIImage? = nil) {

        super.init(title: title, titleColor: titleColor, backgroundColor: backgroundColor, image: image)
        initialize()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        adjustShadowFrame()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Metods

    private func initialize() {
        layer.insertSublayer(shadowLayer, at: 0)

        addTarget(self, action: #selector(self.touchedDown), for: .touchDown)
        addTarget(self, action: #selector(self.touchedUp), for: .touchUpInside)
        addTarget(self, action: #selector(self.touchedUp), for: .touchUpOutside)
    }

    private func adjustShadowFrame() {
        let delta = (bounds.maxX - bounds.maxY) / 2.0

        CATransaction.begin()
        CATransaction.setDisableActions(true)

        if delta < 0 {
            let scale = (1.0 - shadowUpScale) * bounds.maxY
            shadowLayer.frame = bounds.insetBy(dx: delta + scale, dy: scale)
        } else {
            let scale = (1.0 - shadowUpScale) * bounds.maxX
            shadowLayer.frame = bounds.insetBy(dx: scale, dy: scale - delta)
        }

        shadowLayer.cornerRadius = shadowLayer.frame.height / 2.0

        CATransaction.commit()
    }

    @objc private func touchedDown() {
        shadowLayer.opacity = shadowOpacity

        imageView?.layer.transform = CATransform3DMakeScale(imageViewDownScale, imageViewDownScale, 0.0)
    }

    @objc private func touchedUp() {
        CATransaction.begin()

        let transformAnimation = CABasicAnimation(keyPath: "transform")
        transformAnimation.fromValue = CATransform3DIdentity
        transformAnimation.toValue = CATransform3DMakeScale(1.2, 1.2, 1.0)
        transformAnimation.duration = 0.25
        shadowLayer.add(transformAnimation, forKey: "transform")

        shadowLayer.opacity = 0.0

        CATransaction.commit()

        imageView?.layer.transform = CATransform3DIdentity
    }
}
