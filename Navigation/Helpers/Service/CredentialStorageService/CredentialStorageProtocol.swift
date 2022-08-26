//
//  CredentialStorageProtocol.swift
//  Navigation
//
//  Created by Павел Барташов on 26.08.2022.
//

protocol CredentialStorageProtocol {
    func retrieve() throws -> (login: String, password: String)?
    func persist(login: String, password: String) throws
}
