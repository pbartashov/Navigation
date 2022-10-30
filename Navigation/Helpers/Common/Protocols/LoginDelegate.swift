//
//  LoginDelegate.swift
//  Navigation
//
//  Created by Павел Барташов on 30.06.2022.
//

import LocalAuthentication

protocol LoginDelegate: AnyObject {
    var biometryType: LABiometryType { get }

    func checkCredentials(login: String,
                          password: String,
                          completion: ((Result<String, Error>) -> Void)?)

    func signUp(login: String,
                password: String,
                completion: ((Result<String, Error>) -> Void)?)

    func authorizeLocalIfPossible(_ authorizationFinished: @escaping (Bool, LoginError?) -> Void)
}
