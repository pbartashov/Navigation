//
//  MapManager.swift
//  Navigation
//
//  Created by Павел Барташов on 22.10.2022.
//

import CoreLocation
import MapKit
import UIKit

final class MapManager: NSObject {

    // MARK: - Properties

    private let locationManager = CLLocationManager()

    private var locations: [CLLocationCoordinate2D] = []

    // MARK: - Views

    weak var mapView: MKMapView?

    // MARK: - LifeCicle

    deinit {
        locationManager.stopUpdatingLocation()
    }

    // MARK: - Metods

    func configure() {
        locationManager.delegate = self
        checkLocationAuthorization()
        configureLocationManager()
    }

    private func configureLocationManager() {
        locationManager.desiredAccuracy = 1.5
        locationManager.distanceFilter = 2
        locationManager.startUpdatingLocation()
    }

    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse:
                mapView?.showsUserLocation = true
            case .denied, .restricted:
                assertionFailure("User denied location access")
                // Here we can ask a user to go to settings and grant location access
                break
            case .authorizedAlways:
                assertionFailure("Not supported mode, we only need authorization when in use")
                break
            @unknown default:
                assertionFailure("Not supported mode")
                break
        }
    }

    func showNavigationRouteTo(coordinate: CLLocationCoordinate2D, from: CLLocationCoordinate2D?) {
        let sourceCoordinate: CLLocationCoordinate2D

        if let fromCoordinate = from {
            sourceCoordinate = fromCoordinate
        } else if let gpsCoordinate = locationManager.location?.coordinate {
            sourceCoordinate = gpsCoordinate
        } else {
            print("Souce location has not been set")
            return
        }

        // Create a direction request
        let directionRequest = MKDirections.Request()

        // Create source and destination items
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)

        let destinationPlacemark = MKPlacemark(coordinate: coordinate)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

        // Configure a direction request
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .walking

        // Calculate direction
        let directions = MKDirections(request: directionRequest)
        directions.calculate { [weak self] response, error in
            guard let self = self else {
                return
            }

            if error != nil {
                // Here we can show error alert to a user
                return
            }

            guard let response = response, let route = response.routes.first else {
                // Here we can show error alert to a user
                return
            }

            self.mapView?.addOverlay(route.polyline, level: .aboveRoads)
            //            let routeRect = route.polyline.boundingMapRect
            //            self.mapView?.setRegion(MKCoordinateRegion(routeRect), animated: true)
        }
    }

    private func centerAndZoomInMapToLocation(_ location: CLLocationCoordinate2D) {
        // Center map to location
        mapView?.setCenter(location, animated: true)

        // Set region of the map (zooms in on it)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView?.setRegion(region, animated: true)

        mapView?.showsUserLocation = true
    }

    func displayLocations(_ locations: [Location]) {
        guard let mapView = mapView else { return }

        mapView.removeAnnotations(mapView.annotations)

        self.locations = locations.map { $0.clLocation }
        let annotations = locations.map { location in
            let clLocation = location.clLocation
            let pin = MKPointAnnotation()
            pin.title = location.name
            pin.coordinate = clLocation
            return pin
        }

        mapView.addAnnotations(annotations)
    }

    func removeAllRoutes() {
        guard let mapView = mapView else { return }
        mapView.removeOverlays(mapView.overlays)
    }
}

extension MapManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }

        centerAndZoomInMapToLocation(location.coordinate)
    }
}

extension MapManager: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 98.0/255.0,
                                       green: 150.0/255.0,
                                       blue: 119.0/255.0,
                                       alpha: 1)
        renderer.lineWidth = 5.0
        return renderer
    }
}
