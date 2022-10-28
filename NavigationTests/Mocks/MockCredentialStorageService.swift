//
//  MockCredentialStorageService.swift
//  NavigationTests
//
//  Created by Павел Барташов on 28.10.2022.
//

@testable import Navigation

final class MockCredentialStorageService: CredentialStorageProtocol {

    // MARK: - Properties

    var login = "login"
    var password = "password"
    var hasStoredCredentials = false
    var isPersisted = false

    // MARK: - Metods

    func retrieve() throws -> (login: String, password: String)? {
        guard hasStoredCredentials else {
            return nil
        }

        return (login: login, password: password)
    }

    func persist(login: String, password: String) throws {
        isPersisted = true
    }
}
