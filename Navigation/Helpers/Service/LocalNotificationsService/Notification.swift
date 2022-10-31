//
//  Notification.swift
//  Navigation
//
//  Created by Павел Барташов on 31.10.2022.
//

enum Notification {

    static let categoryID = "navigation.notification.updates"

    enum Action {
        case showProfile
        case showFavorites
        case showMap

        var id: String {
            switch self {
                case .showProfile:
                    return "navigation.notification.updates.showProfile"

                case .showFavorites:
                    return "navigation.notification.updates.showFavorites"

                case .showMap:
                    return "navigation.notification.updates.showMap"
            }
        }
    }
}
