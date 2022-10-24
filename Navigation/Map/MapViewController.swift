//
//  MapViewController.swift
//  Navigation
//
//  Created by Павел Барташов on 22.10.2022.
//

//import CoreLocation
import MapKit
import UIKit

protocol MapViewProtocol: AnyObject {
    func displayLocations(_ locations: [Location])
}

final class MapViewController: UIViewController, UIGestureRecognizerDelegate, MapViewProtocol {

    // MARK: - Properties

    private let presenter: MapPresenterProtocol
    private let manager: MapManager
    private var mapType: MKMapType {
        get {
            mapView.mapType
        }
        set {
            mapView.mapType = newValue
            mapTypeButton.setTitle(newValue.name, for: .normal)
        }
    }

    // MARK: - Views

    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.mapType = .standard
        view.showsTraffic = true
        view.delegate = manager
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    private lazy var mapTypeButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.setTitle(mapType.name, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.addTarget(self, action: #selector(handleMapTypeButtonTapped), for: .touchUpInside)

        return button
    }()

    private lazy var removeAllWaypointsButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.setTitle("removeAllWaypointsButtonMapViewController".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.addTarget(self, action: #selector(handleRemoveAllWaypointsButton), for: .touchUpInside)

        return button
    }()

    // MARK: - LifeCicle

    init(presenter: MapPresenterProtocol,
         manager: MapManager) {
        self.presenter = presenter
        self.manager = manager
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        presenter.requestBranchLocations()
    }

    // MARK: - Metods

    private func initialize() {
        view.backgroundColor = .white

        [mapView,
         mapTypeButton,
         removeAllWaypointsButton
        ].forEach {
            view.addSubview($0)
        }

        configureConstraints()

        manager.mapView = mapView
        manager.configure()
        addGestureRecognizer()
    }

    func displayLocations(_ locations: [Location]) {
        manager.displayLocations(locations)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            mapTypeButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 16),
            mapTypeButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 16),

            removeAllWaypointsButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 16),
//            removeAllWaypointsButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -16)
            removeAllWaypointsButton.centerXAnchor.constraint(equalTo: mapView.centerXAnchor)
        ])
    }

    private func addGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleMapViewTap))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }

    @objc
    func handleMapViewTap(gestureRecognizer: UITapGestureRecognizer) {
       let point = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)

        let fromCoordinate = presenter.locations.last?.clLocation

        presenter.addLocations(latitude: coordinate.latitude, longitude: coordinate.longitude)

        manager.showNavigationRouteTo(coordinate: coordinate, from: fromCoordinate)
    }

    @objc
    private func handleMapTypeButtonTapped() {
        mapType = mapType.next
    }

    @objc
    private func handleRemoveAllWaypointsButton() {
        presenter.removeAllLocations()
        manager.removeAllRoutes()
    }

}

fileprivate extension MKMapType {
    var next: MKMapType {
        switch self {
            case .standard:
                return .satellite

            case .satellite:
                return .hybrid

            case .hybrid:
                return .satelliteFlyover

            case .satelliteFlyover:
                return.hybridFlyover

            case .hybridFlyover:
                return .mutedStandard

            case .mutedStandard:
                return .standard

            @unknown default:
                return .standard
        }
    }

    var name: String {
        switch self {
            case .standard:
                return "standardMKMapType".localized

            case .satellite:
                return "satelliteMKMapType".localized

            case .hybrid:
                return "hybridMKMapType".localized

            case .satelliteFlyover:
                return "satelliteFlyoverMKMapType".localized

            case .hybridFlyover:
                return "hybridFlyoverMKMapType".localized

            case .mutedStandard:
                return "mutedStandardMKMapType".localized

            @unknown default:
                return "unknownMKMapType".localized
        }
    }
}
