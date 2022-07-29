//
//  AppConfiguration.swift
//  Navigation
//
//  Created by Павел Барташов on 27.07.2022.
//

enum AppConfiguration {
    case people(id: String)
    case films(id: String)
    case vehicles(id: String)
}

extension AppConfiguration {
    static func random() -> AppConfiguration {
        let random = Int.random(in: 0...2)

        switch random {
            case 0:
                let id = String(Int.random(in: 1...82))
                return .people(id: id)
            case 1:
                let id = String(Int.random(in: 1...6))
                return .films(id: id)
            default:
                let id = String(Int.random(in: 1...39))
                return .vehicles(id: id)
        }
    }

    var description: String {
        switch self {
            case .people:
                return "people"
            case .films:
                return "films"
            case .vehicles:
                return "vehicles"
        }
    }
}
