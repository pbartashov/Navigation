//
//  LoginInspector.swift
//  Navigation
//
//  Created by Павел Барташов on 16.06.2022.
//

final class LoginInspector: LoginDelegate {
    func checkAuthFor(login: String, password: String) throws {
        if login.isEmpty {
            throw LoginError.missingLogin
        }

        if password.isEmpty {
            throw LoginError.missingPassword
        }

        let authPassed = AuthChecker.shared.areValid(loginHash: login.hash, passwordHash: password.hash)

        if !authPassed {
            throw LoginError.authFailed
        }
    }
}
