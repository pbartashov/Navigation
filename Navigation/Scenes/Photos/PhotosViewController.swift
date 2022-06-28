//
//  PhotosViewController.swift
//  Navigation
//
//  Created by Павел Барташов on 24.03.2022.
//

import UIKit
import iOSIntPackage

final class PhotosViewController: UIViewController {

    //MARK: - Properties

    private var photos: [UIImage] = Photos.allPhotos

    //MARK: - Views

    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: collectionViewLayout)

        collectionView.register(PhotosCollectionViewCell.self,
                                forCellWithReuseIdentifier: PhotosCollectionViewCell.identifier)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white

        return collectionView
    }()

    //MARK: - LifeCicle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Photo Gallery"

        view.backgroundColor = .systemGray6
        view.addSubviewsToAutoLayout(collectionView)

        setupLayout()

        runTest()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    //MARK: - Metods

    func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
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


extension PhotosViewController {
    private func runTest() {
        let inputPhotos = photos.flatMap { [$0] + photos[0..<photos.count / 2] }
        let filter: ColorFilter = .posterize
        let qos: QualityOfService = .utility
        let startTime = Date()

        ImageProcessor()
            .processImagesOnThread(sourceImages: inputPhotos,
                                   filter: filter,
                                   qos: qos) { [weak self] images in
                let endTime = Date()

                self?.photos = images.compactMap { image in
                    guard let image = image else { return nil }
                    return UIImage(cgImage: image)
                }

                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }

                let duration = String(format: "%.2f", endTime.timeIntervalSince(startTime))

                print("Test results for \(inputPhotos.count) photos")
                print("filter = \(filter)")
                print("qos = \(qos)")
                print("duration = \(duration)")
            }
    }
}
