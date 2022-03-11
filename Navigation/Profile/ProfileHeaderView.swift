//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Павел Барташов on 10.03.2022.
//

import UIKit

final class ProfileHeaderView: UIView {

    private let image: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 16,
                                              y: 16,
                                              width: 100,
                                              height: 100))
        image.layer.borderWidth = 3
        image.layer.cornerRadius = image.frame.width / 2
        image.layer.masksToBounds = true

        return image
    }()

    private let name: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black

        return label
    }()

    private let status: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray

        return label
    }()

    let buttonShowStatus: UIButton = {
        let button = UIButton()
        button.setTitle("Show status", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 14

        button.layer.shadowOffset = .init(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7

        return button
    }()
       
    override init(frame: CGRect) {
        super.init(frame: frame)

        Initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        Initialize()
    }

    func Initialize() {
        addSubview(image)
        addSubview(name)
        addSubview(status)
        addSubview(buttonShowStatus)

        setViewFrames()
    }

    func setup(with profile: Profile) {
        image.image = profile.image
        name.text = profile.name
        status.text = profile.status
    }

    func setViewFrames() {

        let safeArea = frame.inset(by: safeAreaInsets)
        let container = CGRect(origin: CGPoint(x: safeAreaInsets.left + 16,
                                               y: safeAreaInsets.top + 16),
                               size: CGSize(width: safeArea.width - 16 - 16,
                                            height: 16 + 100 + 16 + 50))

        image.frame.origin = container.origin

        let labelWidth = container.width - image.frame.width - 16

        name.frame = CGRect(x: image.frame.maxX + 16,
                            y: safeAreaInsets.top + 27,
                            width: labelWidth,
                            height: 22)

        status.frame = CGRect(x: image.frame.maxX + 16,
                              y: name.frame.maxY + 31,
                              width: labelWidth,
                              height: 18)

        buttonShowStatus.frame = CGRect(x: container.minX,
                                        y:  image.frame.maxY + 16,
                                        width: container.width,
                                        height: 50)
    }
}
