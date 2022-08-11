//
//  CheckerService.swift
//  Navigation
//
//  Created by Павел Барташов on 08.08.2022.
//

import FirebaseAuth

struct CheckerService: CheckerServiceProtocol {

    // MARK: - Metods

    func checkCredentials(email: String, password: String, completion: ((Result<String, Error>) -> Void)?) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            handle(authResult: authResult, error: error, with: completion)
        }
    }
    
    func signUp(email: String, password: String, completion: ((Result<String, Error>) -> Void)?) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            handle(authResult: authResult, error: error, with: completion)
        }
    }
    
    private func handle(authResult: AuthDataResult?,
                        error: Error?,
                        with completion: ((Result<String, Error>) -> Void)?
    ) {
        if let error = error as? NSError {
            completion?(.failure(error.convertedToLoginError))
            return
        }
        
        guard let authResult = authResult else {
            completion?(.failure(LoginError.unknown))
            return
        }
        
        completion?(.success(authResult.user.email ?? ""))
    }
}

fileprivate extension NSError {
    var convertedToLoginError: LoginError {
        guard let errorCode = AuthErrorCode.Code(rawValue: code) else {
            return .unknown
        }
        
        switch errorCode {
            case .userNotFound:
                return .userNotFound
                
            case .invalidEmail:
                return .invalidEmail
                
            case .wrongPassword:
                return .wrongPassword
                
            case .weakPassword:
                return .weakPassword
                
            case.networkError:
                return .networkError
                
            default:
                return .unknown
        }
    }
}
