//
//  Credentials.swift
//  Navigation
//
//  Created by Павел Барташов on 26.08.2022.
//

import RealmSwift

final class Credentials: Object {
    @Persisted var login: String = ""
    @Persisted var password: String = ""
    
    convenience init(login: String, password: String) {
        self.init()
        self.login = login
        self.password = password
    }
}
