//
//  CurrentUserService.swift
//  Navigation
//
//  Created by Павел Барташов on 14.06.2022.
//

import Foundation

final class CurrentUserService: UserService {
    private let currentUser: User

    init(currentUser: User) {
        self.currentUser = currentUser
    }

    func getUser(byName name: String) -> User? {
        name == currentUser.name ? currentUser : nil
    }    
}
