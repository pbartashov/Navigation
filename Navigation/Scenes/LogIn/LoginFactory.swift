//
//  LoginFactory.swift
//  Navigation
//
//  Created by Павел Барташов on 18.06.2022.
//

struct LoginFactory {
    func viewModelWith(loginDelegate: LoginDelegate,
                       coordinator: LoginCoordinator) -> LoginViewModel {

        let allowedCharacters: String = String().printable
        let bruteForcer = BruteForcerV2(allowedCharacters: allowedCharacters)
        let bruteForceService = OperationBruteForceService(bruteForcer: bruteForcer)

        return LoginViewModel(loginDelegate: loginDelegate,
                              coordinator: coordinator,
                              bruteForceService: bruteForceService)
    }
}
