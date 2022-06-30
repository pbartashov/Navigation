//
//  LoginFactory.swift
//  Navigation
//
//  Created by Павел Барташов on 18.06.2022.
//

struct LoginFactory {
    func viewModelWith(loginDelegate: LoginDelegate,
                       coordinator: LoginCoordinator) -> LoginViewModel {

        LoginViewModel(loginDelegate: loginDelegate, coordinator: coordinator)
    }
}
