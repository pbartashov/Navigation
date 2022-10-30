//
//  LoginInspector.swift
//  Navigation
//
//  Created by Павел Барташов on 16.06.2022.
//

import LocalAuthentication

final class LoginInspector: LoginDelegate {

    // MARK: - Properties

    private let checker: CheckerServiceProtocol
    private let localChecker: LocalAuthorization

    var biometryType: LABiometryType {
        localChecker.biometryType
    }

    // MARK: - LifeCicle

    init(checker: CheckerServiceProtocol,
         localChecker: LocalAuthorization = LocalAuthorizationService()
    ) {
        self.checker = checker
        self.localChecker = localChecker
    }

    // MARK: - Metods

    func checkCredentials(login: String, password: String, completion: ((Result<String, Error>) -> Void)?) {
        if login.isEmpty {
            completion?(.failure(LoginError.missingLogin))
            return
        }

        if password.isEmpty {
            completion?(.failure(LoginError.missingPassword))
            return
        }

        checker.checkCredentials(email: login, password: password, completion: completion)
    }

    func signUp(login: String, password: String, completion: ((Result<String, Error>) -> Void)?) {
        checker.signUp(email: login, password: password, completion: completion)
    }

    func authorizeLocalIfPossible(_ authorizationFinished: @escaping (Bool, LoginError?) -> Void) {
        localChecker.authorizeIfPossible(authorizationFinished)
    }
}
