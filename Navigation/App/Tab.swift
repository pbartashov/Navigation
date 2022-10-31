//
//  Tab.swift
//  Navigation
//
//  Created by Павел Барташов on 31.10.2022.
//

enum Tab: Int {
    case feed = 0
    case profile
    case favorites
    case map

    var index: Int {
        self.rawValue
    }
}
