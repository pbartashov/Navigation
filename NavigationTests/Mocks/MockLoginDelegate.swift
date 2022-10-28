//
//  MockLoginDelegate.swift
//  NavigationTests
//
//  Created by Павел Барташов on 28.10.2022.
//

import XCTest
@testable import Navigation

final class MockLoginDelegate: LoginDelegate {

    // MARK: - Properties
    let login = "login"
    let password = "password"
    var isSignedUp = false

    var expectation: XCTestExpectation?

    // MARK: - Metods

    func checkCredentials(login: String,
                          password: String,
                          completion: ((Result<String, Error>) -> Void)?) {

        if login.isEmpty {
            completion?(.failure(LoginError.missingLogin))
            return
        }

        if password.isEmpty {
            completion?(.failure(LoginError.missingPassword))
            return
        }

        guard login == self.login else {
            completion?(.failure(LoginError.userNotFound))
            return
        }

        guard password == self.password else {
            completion?(.failure(LoginError.wrongPassword))
            return
        }

        completion?(.success(self.login))
    }

    func signUp(login: String,
                password: String,
                completion: ((Result<String, Error>) -> Void)?) {

        isSignedUp = true
        completion?(.success(self.login))

        expectation?.fulfill()
    }
}
