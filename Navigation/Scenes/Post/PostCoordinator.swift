//
//  PostCoordinator.swift
//  Navigation
//
//  Created by Павел Барташов on 25.06.2022.
//

import UIKit

final class PostCoordinator: NavigationCoordinator {

    //MARK: - Metods

    func showInfo() {
        let infoViewController = InfoViewController()
        navigationController?.present(infoViewController, animated: true, completion: nil)
    }
}
