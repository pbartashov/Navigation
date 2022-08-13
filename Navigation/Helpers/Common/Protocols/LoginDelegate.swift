//
//  LoginDelegate.swift
//  Navigation
//
//  Created by Павел Барташов on 30.06.2022.
//

protocol LoginDelegate: AnyObject {
    func checkCredentials(login: String,
                          password: String,
                          completion: ((Result<String, Error>) -> Void)?)

    func signUp(login: String,
                password: String,
                completion: ((Result<String, Error>) -> Void)?)
}
