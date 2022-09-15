//
//  PhotosCollectionViewCell.swift
//  Navigation
//
//  Created by Павел Барташов on 24.03.2022.
//

import UIKit

final class PhotosCollectionViewCell: UICollectionViewCell {

    //MARK: - Views

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()

        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    //MARK: - LifeCicle

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(imageView)

        setupLayouts()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    //MARK: - Metods

    private func setupLayouts() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(contentView.snp.width)
        }
    }

    func setup(with image: UIImage) {
        imageView.image = image
    }
}
