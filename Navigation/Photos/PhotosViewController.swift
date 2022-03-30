//
//  PhotosViewController.swift
//  Navigation
//
//  Created by Павел Барташов on 24.03.2022.
//

import UIKit

final class PhotosViewController: UIViewController {

    private let photos: [UIImage] = Photos.allPhotos

    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
//        Для нашей задачи можно использовать эти свойства, либо методы делегата UICollectionViewDelegateFlowLayout
//        collectionViewLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
//        collectionViewLayout.minimumInteritemSpacing = 8
//        collectionViewLayout.minimumLineSpacing = 8

        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: collectionViewLayout)

        collectionView.register(PhotosCollectionViewCell.self,
                                forCellWithReuseIdentifier: PhotosCollectionViewCell.identifier)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Photo Gallery"

        view.backgroundColor = .systemGray6

        view.addSubviewsToAutoLayout(collectionView)

        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
 }

// MARK: - UICollectionViewDataSource methods
extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.identifier,
                                                      for: indexPath)
            as! PhotosCollectionViewCell

        cell.setup(with: photos[indexPath.row])

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout methods
extension PhotosViewController: UICollectionViewDelegateFlowLayout {

    private var itemsPerRow: CGFloat { 3 }
    private var spacing: CGFloat { 8 }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let paddingSpace = spacing * (itemsPerRow + 1)
        let availableWidth = view.safeAreaLayoutGuide.layoutFrame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        spacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int)
    -> CGFloat {
        spacing
    }
}

