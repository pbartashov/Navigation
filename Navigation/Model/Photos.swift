//
//  Photos.swift
//  Navigation
//
//  Created by Павел Барташов on 23.03.2022.
//

import UIKit

struct Photos {
    //MARK: - Properties
    static let totalPhotosCount = 20

    static var allPhotos: [UIImage] {
        getPhotos(withIndexes: [Int](1...totalPhotosCount))
    }

    //MARK: - Metods
    static func randomPhotos(ofCount count: Int) -> [UIImage] {
        let randomIndexes = getUniqueRandomNumbers(min: 1, max: totalPhotosCount, count: count)
        return getPhotos(withIndexes: randomIndexes)
    }

    static func getPhotos(withIndexes indexes: [Int]) -> [UIImage] {
        var photos = [UIImage]()

        indexes.forEach { index in
            if let photo = UIImage(named: "photo-\(index)") {
                photos.append(photo)
            }
        }

        return photos
    }
}
