//
//  LoginInspector.swift
//  Navigation
//
//  Created by Павел Барташов on 16.06.2022.
//

final class LoginInspector: LoginDelegate {
    func authPassedFor(login: String, password: String) -> Bool {
        AuthChecker.shared.areValid(loginHash: login.hash, passwordHash: password.hash)
    }
}
