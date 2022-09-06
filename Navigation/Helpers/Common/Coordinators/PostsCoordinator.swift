//
//  PostsCoordinator.swift
//  Navigation
//
//  Created by Павел Барташов on 07.09.2022.
//

import Foundation

final class PostsCoordinator: NavigationCoordinator {

    //MARK: - Metods

    func showSearchPrompt(comletion: ((String) -> Void)? = nil) {
        let photosViewController = PhotosViewController()
        navigationController?.pushViewController(photosViewController, animated: true)
    }
}
