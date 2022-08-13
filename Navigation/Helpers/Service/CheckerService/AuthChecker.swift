//
//  AuthChecker.swift
//  Navigation
//
//  Created by Павел Барташов on 15.06.2022.
//

final class AuthChecker {
    static let shared = AuthChecker()
    
    private let loginHash = "Octopus".hash
    private let passwordHash = "123".hash

    private init() {}

    func areValid(loginHash: Int, passwordHash: Int) -> Bool {
        self.loginHash == loginHash
            && self.passwordHash == passwordHash
    }
}
