//
//  PhotosTableViewCell.swift
//  Navigation
//
//  Created by Павел Барташов on 23.03.2022.
//

import UIKit

class PhotosTableViewCell: UITableViewCell {
    //MARK: - Properties
    let photosCount = 4
    private let padding: CGFloat = 12
    private let interPhotoSpacing: CGFloat = 8

    //MARK: - Views
    lazy private var titleLabel: UILabel = {
        let label = UILabel()

        label.text = "Photos"
        label.textColor = .black
        label.font = .systemFont(ofSize: 24, weight: .bold)

        return label
    }()

    lazy private  var arrowLabel: UILabel = {
        let label = UILabel()

        label.text = "→"
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .right

        return label
    }()

    lazy private var photoStack: UIStackView = {
        let stack = UIStackView()

        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = interPhotoSpacing

        (0..<photosCount).forEach { _ in
            let imageView = UIImageView()

            imageView.layer.cornerRadius = 4
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
 
            stack.addArrangedSubview(imageView)
        }

        return stack
    }()

    //MARK: - LifeCicle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubviewsToAutoLayout(titleLabel,
                                            arrowLabel,
                                            photoStack)
        setupLayouts()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    //MARK: - Metods
    private func setupLayouts() {
        //photoStack.height = (1 / 4) * (photoStack.width - 3 * 8)
        //180 = 0.25 * 744 - 0.25 * 3 * 8
        let photosCountFloat = CGFloat(photosCount)
        let multiplier = 1.0 / photosCountFloat
        let constant = multiplier * (photosCountFloat - 1.0) * interPhotoSpacing

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),

            arrowLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            arrowLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            arrowLabel.heightAnchor.constraint(equalTo: titleLabel.heightAnchor),
            arrowLabel.widthAnchor.constraint(equalTo: arrowLabel.heightAnchor),

            photoStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            photoStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            photoStack.trailingAnchor.constraint(equalTo: arrowLabel.trailingAnchor),
            photoStack.heightAnchor.constraint(equalTo: photoStack.widthAnchor, multiplier: multiplier, constant: -constant),

            contentView.bottomAnchor.constraint(equalTo: photoStack.bottomAnchor, constant: padding)
        ])
    }

    func setup(with photos: [UIImage]) {
        (0..<min(photos.count, photoStack.arrangedSubviews.count))
            .forEach { index in
                let imageView = photoStack.arrangedSubviews[index] as! UIImageView
                imageView.image = photos[index]
        }
    }
}
