//
//  MockLoginCoordinator.swift
//  NavigationTests
//
//  Created by Павел Барташов on 28.10.2022.
//

import Foundation
@testable import Navigation

final class MockLoginCoordinator: LoginCoordinatorProtocol {

    //MARK: - Properties

    var isMainSceneShown = false
    var isHintTimerStarted = false
    var isCreateAccountShown = false

    //MARK: - Metods

    func showMainScene(for userName: String) {
        isMainSceneShown = true
    }

    func startHintTimer() {
        isHintTimerStarted = true
    }

    func showCreateAccount(for login: String,
                           completion: (()-> Void)? = nil) {
        isCreateAccountShown = true

        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
            completion?()
        }
    }
}
