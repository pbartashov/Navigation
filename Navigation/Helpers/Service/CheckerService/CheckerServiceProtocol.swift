//
//  CheckerServiceProtocol.swift
//  Navigation
//
//  Created by Павел Барташов on 08.08.2022.
//

protocol CheckerServiceProtocol {
    func checkCredentials(email: String,
                          password: String,
                          completion: ((Result<String, Error>) -> Void)?)

    func signUp(email: String,
                password: String,
                completion: ((Result<String, Error>) -> Void)?)
}
