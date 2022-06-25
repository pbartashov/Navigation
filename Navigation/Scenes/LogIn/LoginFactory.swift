//
//  LoginFactory.swift
//  Navigation
//
//  Created by Павел Барташов on 18.06.2022.
//

protocol LoginFactory {
    func createLoginInsoector() -> LoginInspector
}

struct LoginFactoryImp: LoginFactory {
    func createLoginInsoector() -> LoginInspector {
        LoginInspector()
    }
}
