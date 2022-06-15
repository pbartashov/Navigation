//
//  User.swift
//  Navigation
//
//  Created by Павел Барташов on 14.06.2022.
//

import UIKit

final class User {
    var name: String
    var avatar: UIImage?
    var status: String

    init(name: String = "",
         avatar: UIImage? = UIImage(systemName: "person"),
         status: String = "") {

        self.name = name
        self.avatar = avatar
        self.status = status
    }
}
