//
//  SWAPIService.swift
//  Navigation
//
//  Created by Павел Барташов on 01.08.2022.
//

import Foundation

struct SWAPIService {

    // MARK: - Properties

    private let networkService = NetworkService()
    private let baseURLString = "https://swapi.dev/api/"

    private let completionQueue = DispatchQueue(label: "com.navigation.networkService.completionQueue")

    // MARK: - Metods

    func getPlanet(id: String, comletion: @escaping (Result<PlanetModel, InfoServiceError>) -> Void) {
        let urlString = "\(baseURLString)planets/\(id)"

        networkService.request(with: urlString) { result in
            switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let planet = try decoder.decode(PlanetModel.self, from: data)

                        comletion(.success(planet))

                    } catch {
                        comletion(.failure(.init(error)))
                    }

                case .failure(let error):
                    comletion(.failure(.init(error)))
            }
        }
    }

    func getPerson(id: String, comletion: @escaping (Result<Person, InfoServiceError>) -> Void) {
        let urlString = "\(baseURLString)people/\(id)"
        getPerson(url: urlString, comletion: comletion)
    }

    func getPerson(url: String, comletion: @escaping (Result<Person, InfoServiceError>) -> Void) {
        networkService.request(with: url) { result in
            switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let person = try decoder.decode(Person.self, from: data)

                        comletion(.success(person))

                    } catch {
                        comletion(.failure(.init(error)))
                    }

                case .failure(let error):
                    comletion(.failure(.init(error)))
            }
        }
    }

    func getPeopleAsync(urls: [String], comletion: @escaping (Result<Person, InfoServiceError>) -> Void) {
        for url in urls {
            getPerson(url: url) { result in
                switch result {
                    case .success(let person):
                        completionQueue.async {
                            comletion(.success(person))
                        }

                    case .failure(let error):
                        comletion(.failure(.init(error)))
                }
            }
        }
    }
}
