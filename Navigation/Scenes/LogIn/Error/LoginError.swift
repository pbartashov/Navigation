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
    case biometricUnknown
    case biometryNotEnrolled
    case biometryNotAvailable
}

extension LoginError : LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .missingLogin:
                return "missingLoginLoginError".localized

            case .missingPassword:
                return "missingPasswordLoginError".localized

            case .invalidEmail:
                return "invalidEmailLoginError".localized

            case .wrongPassword:
                return "wrongPasswordLoginError".localized

            case .weakPassword:
                return "weakPasswordLoginError".localized

            case .userNotFound:
                return "userNotFoundLoginError".localized

            case .networkError:
                return "networkErrorLoginError".localized

            case .unknown:
                return "unknownLoginError".localized
                
            case .biometricUnknown:
                return "biometricUnknownLoginError".localized

            case .biometryNotEnrolled:
                return "biometryNotEnrolledLoginError".localized
                
            case .biometryNotAvailable:
                return "biometryNotAvailableLoginError".localized
        }
    }
}
