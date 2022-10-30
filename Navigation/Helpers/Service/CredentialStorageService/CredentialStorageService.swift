//
//  CredentialStorageService.swift
//  Navigation
//
//  Created by Павел Барташов on 26.08.2022.
//

import RealmSwift

struct CredentialStorageService: CredentialStorageProtocol {

    // MARK: - Properties

    private let config = Realm.Configuration(encryptionKey: KeychainKeyStorage.getKey())

    // MARK: - Metods

    func retrieve() throws -> (login: String, password: String)? {
        guard let credentials = try retrieveCredentials() else {
            return nil
        }

        return (login: credentials.login, password: credentials.password)
    }

    func persist(login: String, password: String) throws {
        if let credentials = try retrieveCredentials() {
            try update(credentials: credentials, withLogin: login, password: password)
        } else {
            try createCredentials(withLogin: login, password: password)
        }
    }

    private func retrieveCredentials() throws -> Credentials? {
        try Realm(configuration: config).objects(Credentials.self).first
    }

    private func createCredentials(withLogin login: String, password: String) throws {
        let realm = try Realm(configuration: config)

        try realm.write {
            let credentials = Credentials(login: login, password: password)
            realm.add(credentials)
        }
    }

    private func update(credentials: Credentials, withLogin login: String, password: String) throws {
        try Realm(configuration: config).write {
            credentials.login = login
            credentials.password = password
        }
    }
}
