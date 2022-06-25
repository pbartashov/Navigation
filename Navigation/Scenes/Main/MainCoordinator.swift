//
//  MainCoordinator.swift
//  Navigation
//
//  Created by Павел Барташов on 25.06.2022.
//

import UIKit

protocol MainCoordinatorProtocol {
    func start()
}

class MainCoordinator {
    private var feedCoordinator = FeedCoordinator()
    private var profileCoordinator = ProfileCoordinator()

    func start() {
        ()
    }
}
