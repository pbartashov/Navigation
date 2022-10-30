//
//  MockErrorPresenter.swift
//  NavigationTests
//
//  Created by Павел Барташов on 28.10.2022.
//

@testable import Navigation

final class MockErrorPresenter: ErrorPresenterProtocol {
    
    // MARK: - Properties

    var isErrorShownShown = false

    // MARK: - Metods

    func show(error: Error) {
        isErrorShownShown = true
    }
}
