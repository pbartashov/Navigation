//
//  Location.swift
//  Navigation
//
//  Created by Павел Барташов on 22.10.2022.
//

import CoreLocation

struct Location {
    let name: String?
    let latitude: Double
    let longitude: Double
}

extension Location {
    var clLocation: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
