//
//  LoginDelegate.swift
//  Navigation
//
//  Created by Павел Барташов on 30.06.2022.
//

protocol LoginDelegate: AnyObject {
    func checkAuthFor(login: String, password: String) throws
}