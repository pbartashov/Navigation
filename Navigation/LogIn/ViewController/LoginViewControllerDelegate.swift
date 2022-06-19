//
//  LoginViewControllerDelegate.swift
//  Navigation
//
//  Created by Павел Барташов on 16.06.2022.
//

protocol LoginViewControllerDelegate: AnyObject {
    func authPassedFor(login: String, password: String) -> Bool
}
