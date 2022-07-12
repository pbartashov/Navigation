//
//  UserService.swift
//  Navigation
//
//  Created by Павел Барташов on 14.06.2022.
//

protocol UserService {
    func getUser(byName name: String) throws -> User
}
