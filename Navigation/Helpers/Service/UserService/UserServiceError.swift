//
//  UserServiceError.swift
//  Navigation
//
//  Created by Павел Барташов on 09.07.2022.
//

import Foundation

enum UserServiceError: Error {
    case wrongUserName
}

extension UserServiceError : LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .wrongUserName:
                return NSLocalizedString("Неверное имя пользователя.", comment: "")
        }
    }
}
