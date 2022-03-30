//
//  PhotosCollectionViewCell.swift
//  Navigation
//
//  Created by Павел Барташов on 24.03.2022.
//

import UIKit

final class PhotosCollectionViewCell: UICollectionViewCell {

    lazy private  var imageView: UIImageView = {
        let imageView = UIImageView()

        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubviewsToAutoLayout(imageView)

        setupLayouts()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupLayouts() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),

            contentView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
    }

    func setup(with image: UIImage) {
        imageView.image = image
    }
}
