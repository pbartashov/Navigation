//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by Павел Барташов on 25.06.2022.
//

import UIKit

final class ProfileCoordinator: NavigationCoordinator {

    //MARK: - Metods

    func showPhotos() {
        let photosViewController = PhotosViewController()
        navigationController?.pushViewController(photosViewController, animated: true)
    }
}
