//
//  NavigationTests.swift
//  NavigationTests
//
//  Created by Павел Барташов on 27.10.2022.
//

import XCTest
@testable import Navigation

final class LoginViewModelTests: XCTestCase {

    // MARK: - Properties

    var viewModel: LoginViewModel!
    
    var loginDelegate: MockLoginDelegate!
    var coordinator: MockLoginCoordinator!
    var credentialStorage: MockCredentialStorageService!
    var errorPresenter: MockErrorPresenter!

    // MARK: - Metods

    override func setUpWithError() throws {
        loginDelegate = MockLoginDelegate()
        coordinator = MockLoginCoordinator()
        credentialStorage = MockCredentialStorageService()
        errorPresenter = MockErrorPresenter()

        viewModel = LoginViewModel(loginDelegate: loginDelegate,
                                   coordinator: coordinator,
                                   credentialStorage: credentialStorage,
                                   errorPresenter: errorPresenter)
    }

    func testLoginPasswordRight() {
        let login = "login"
        let password = "password"

        viewModel.perfomAction(.authWith(login: login, password: password))

        guard case .processing(login: login, password: password) = viewModel.state else {
            return XCTFail("State is not right")
        }

        XCTAssertTrue(coordinator.isMainSceneShown)
        XCTAssertFalse(coordinator.isCreateAccountShown)
        XCTAssertFalse(errorPresenter.isErrorShownShown)
    }

    func testLoginWrong() {
        let login = "wronglogin"
        let password = "password"
        let expectation = expectation(description: "completion should be called")
        loginDelegate.expectation = expectation

        viewModel.perfomAction(.authWith(login: login, password: password))

        guard case .processing(login: login, password: password) = viewModel.state else {
            return XCTFail("State is not right")
        }

        XCTAssertFalse(coordinator.isMainSceneShown)
        XCTAssertTrue(coordinator.isCreateAccountShown)
        XCTAssertFalse(errorPresenter.isErrorShownShown)

        wait(for: [expectation], timeout: 1.5)
    }

    func testPasswordWrong() {
        let login = "login"
        let password = "wrongpassword"

        viewModel.perfomAction(.authWith(login: login, password: password))

        guard case .authFailed = viewModel.state else {
            return XCTFail("State is not right")
        }

        XCTAssertFalse(coordinator.isMainSceneShown)
        XCTAssertFalse(coordinator.isCreateAccountShown)
        XCTAssertTrue(errorPresenter.isErrorShownShown)
    }

    func testAutologinHasStoredCredentials() {
        credentialStorage.hasStoredCredentials = true

        viewModel.perfomAction(.autoLogin)

        guard case .processing = viewModel.state else {
            return XCTFail("State is not right")
        }

        XCTAssertTrue(coordinator.isMainSceneShown)
        XCTAssertFalse(coordinator.isCreateAccountShown)
        XCTAssertFalse(errorPresenter.isErrorShownShown)
    }

    func testAutologinNoStoredCredentials() {
        credentialStorage.hasStoredCredentials = false

        viewModel.perfomAction(.autoLogin)

        guard case .initial = viewModel.state else {
            return XCTFail("State is not right")
        }

        XCTAssertFalse(coordinator.isMainSceneShown)
        XCTAssertFalse(coordinator.isCreateAccountShown)
        XCTAssertFalse(errorPresenter.isErrorShownShown)
    }
}
