//
//  LocalAuthorizationService.swift
//  Navigation
//
//  Created by Павел Барташов on 30.10.2022.
//

import LocalAuthentication

protocol LocalAuthorization {
    var biometryType: LABiometryType { get }
    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool, LoginError?) -> Void)
}

final class LocalAuthorizationService: LocalAuthorization {

    // MARK: - Properties

    let context = LAContext()

    var biometryType: LABiometryType {
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                  error: nil)

        return context.biometryType
    }

    // MARK: - Metods

    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool, LoginError?) -> Void) {
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                        error: &error)
        else {
            handleError(error, authorizationFinished)
            return
        }

        context.evaluatePolicy(
            .deviceOwnerAuthentication,
            localizedReason: "To easy log in"
        ) { success, error in
            if let error = error as? LAError {
                switch error.code {
                    case .appCancel, .userCancel, .systemCancel:
                        authorizationFinished(false, nil)
                        return

                    default:
                        authorizationFinished(false, .biometricUnknown)
                        return
                }
            }

            authorizationFinished(true, nil)
        }
    }
    
    private func handleError(_ error: NSError?, _ authorizationFinished: (Bool, LoginError?) -> Void) {
        if let error = error as? LAError {
            switch error.code {
                case .biometryNotEnrolled:
                    authorizationFinished(false, .biometryNotEnrolled)

                case .biometryNotAvailable:
                    authorizationFinished(false, .biometryNotAvailable)

                default:
                    authorizationFinished(false, .biometricUnknown)
            }
        }
    }
}
