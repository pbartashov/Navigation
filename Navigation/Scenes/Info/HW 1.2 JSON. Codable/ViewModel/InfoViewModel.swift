//
//  InfoViewModel.swift
//  Navigation
//
//  Created by Павел Барташов on 31.07.2022.
//

enum InfoAction {
    case requestData
    case requestPlanet
    case requestResidents(for: PlanetModel)
    case reloadData
}

enum InfoState {
    case initial
    case loadedInfo(InfoModel)

    case loadingPlanet
    case loadedPlanet(PlanetModel)
    case loadingResidents
    case loadedResidents([Person])
    case loadingPlanetCompleted
}

final class InfoViewModel: ViewModel<InfoState, InfoAction> {

    // MARK: - Properties

    private let infoService = InfoService()
    private var infoModel: InfoModel? {
        didSet {
            if let infoModel = infoModel {
                state = .loadedInfo(infoModel)
            } else {
                state = .initial
            }
        }
    }

    private let swapiService = SWAPIService()
    private var planetModel: PlanetModel? {
        didSet {
            if let planetModel = planetModel {
                state = .loadedPlanet(planetModel)
            } else {
                state = .initial
            }
        }
    }

    private(set) var residents: [Person] = [] {
        didSet {
            state = .loadedResidents(residents)
        }
    }
    private var residentsToLoadCount: Int = 0 {
        didSet {
            if residentsToLoadCount == 0 {
                state = .loadingPlanetCompleted
            }
        }
    }

    // MARK: - Metods

    override func perfomAction(_ action: InfoAction) {
        switch action {
            case .requestData:
                requestData()

            case .requestPlanet:
                requestPlanet()

            case .requestResidents(for: let planet):
                requestResidents(for: planet)

            case .reloadData:
                reloadData()
        }
    }

    private func requestData() {
        infoService.getData { [weak self] result in
            switch result {
                case .success(let infoModel):
                    self?.infoModel = infoModel

                case .failure(let error):
                    ErrorPresenter.shared.show(error: error)
            }
        }
    }

    private func requestPlanet() {
        state = .loadingPlanet

        swapiService.getPlanet(id: "1") { [weak self] result in
            switch result {
                case .success(let planet):
                    self?.planetModel = planet
                    self?.perfomAction(.requestResidents(for: planet))
                case .failure(let error):
                    ErrorPresenter.shared.show(error: error)

                    self?.residentsToLoadCount = 0
            }
        }
    }

    private func requestResidents(for planet: PlanetModel) {
        state = .loadingResidents

        residentsToLoadCount = planet.residents.count
        swapiService.getPeopleAsync(urls: planet.residents) { [weak self] result in
            switch result {
                case .success(let person):
                    self?.residents.append(person)

                case .failure(let error):
                    ErrorPresenter.shared.show(error: error)
            }

            self?.residentsToLoadCount -= 1
        }
    }

    private func reloadData() {
        residents.removeAll()

        if infoModel == nil {
            perfomAction(.requestData)
        }

        if let planet = planetModel {
            perfomAction(.requestResidents(for: planet))
        } else {
            perfomAction(.requestPlanet)
        }
    }
}
