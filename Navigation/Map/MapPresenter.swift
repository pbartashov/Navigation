//
//  MapPresenter.swift
//  Navigation
//
//  Created by Павел Барташов on 22.10.2022.
//

protocol MapPresenterProtocol: AnyObject {
    var locations: [Location] { get }

    func requestBranchLocations()
    func addLocations(latitude: Double, longitude: Double)
    func removeAllLocations()
}

final class MapPresenter: MapPresenterProtocol {

    // MARK: - Properties

    weak var view: MapViewProtocol?
    
    var locations: [Location] = [] {
        didSet {
            view?.displayLocations(locations)
        }
    }

    // MARK: - Metods

    func requestBranchLocations() {
        view?.displayLocations(locations)
    }
    
    func addLocations(latitude: Double, longitude: Double) {
        let location = Location(name: "\("waypointNameMapPresenter".localized) \(locations.count + 1)",
                                latitude: latitude,
                                longitude: longitude)
        locations.append(location)
    }
    
    func removeAllLocations() {
        locations.removeAll()
    }
}
