//
//  LoginError.swift
//  Navigation
//
//  Created by Павел Барташов on 08.07.2022.
//

import Foundation

enum LoginError: Error {
    case missingLogin
    case missingPassword
    case authFailed
}

extension LoginError : LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .missingLogin:
                return NSLocalizedString("Введите логин.", comment: "")

            case .missingPassword:
                return NSLocalizedString("Введите пароль.", comment: "")

            case .authFailed:
                return NSLocalizedString("Неверный логин или пароль.", comment: "")
        }
    }
}
