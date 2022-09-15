//
//  LoginInspector.swift
//  Navigation
//
//  Created by Павел Барташов on 16.06.2022.
//

final class LoginInspector: LoginDelegate {

    // MARK: - Properties

    private let checker: CheckerServiceProtocol

    // MARK: - LifeCicle

    init(checker: CheckerServiceProtocol) {
        self.checker = checker
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
}
