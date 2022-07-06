//
//  LoginInspectorFactory.swift
//  Navigation
//
//  Created by Павел Барташов on 30.06.2022.
//

protocol LoginInspectorFactory {
    func createLoginInspector() -> LoginInspector
}

struct LoginInspectorFactoryImp: LoginInspectorFactory {
    func createLoginInspector() -> LoginInspector {
        LoginInspector()
    }
}

