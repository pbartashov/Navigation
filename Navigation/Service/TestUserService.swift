//
//  TestUserService.swift
//  Navigation
//
//  Created by Павел Барташов on 15.06.2022.
//

import Foundation
import UIKit

final class TestUserService: UserService {
    private let testUser = User(name: "Test",
                                status: "Test")

    func getUser(byName name: String) -> User? {
        testUser
    }
}
