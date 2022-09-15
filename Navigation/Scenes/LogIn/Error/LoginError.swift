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
    case invalidEmail
    case wrongPassword
    case weakPassword
    case userNotFound
    case networkError
    case unknown
}

extension LoginError : LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .missingLogin:
                return NSLocalizedString("Введите логин.", comment: "")

            case .missingPassword:
                return NSLocalizedString("Введите пароль.", comment: "")

            case .invalidEmail:
                return NSLocalizedString("Неверный адрес электронной почты.", comment: "")

            case .wrongPassword:
                return NSLocalizedString("Неверный логин или пароль.", comment: "")

            case .weakPassword:
                return NSLocalizedString("Пароль должен содержать не менее 6 символов.", comment: "")

            case .userNotFound:
                return NSLocalizedString("Пользователь не найден.", comment: "")

            case .networkError:
                return NSLocalizedString("Нет подключения к сети.", comment: "")

            case .unknown:
                return NSLocalizedString("Ошибка при авторизации. Попробуйте еще раз.", comment: "")
        }
    }
}
