//
//  NetworkService.swift
//  Navigation
//
//  Created by Павел Барташов on 27.07.2022.
//

import Foundation

struct NetworkService: NetworkServiceProtocol {
    static var baseURL = URL(string: "https://swapi.dev/api/")!

    static func request(for configuration: AppConfiguration) {
        var url = baseURL.appendingPathComponent(configuration.description)

        switch configuration {
            case .people(let id), .films(let id), .vehicles(let id):
                url.appendPathComponent(id)
        }

        print("\nurl = \(url)")

        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if let response = response as? HTTPURLResponse  {
                print("\nresponse:\n.allHeaderFields = \(response.allHeaderFields)\n.statusCode = \(response.statusCode)")
            }

            if let error = error {
                print("\nerror.localizedDescription = \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("Ошибка при получении данных с сервера")
                return
            }

            guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                print("Ошибка при чтении JSON")
                return
            }

            print("\njsonObject:\n\(jsonObject)")
        }

        task.resume()
    }

    func request(with urlString: String,
                 completionHandler: @escaping (Result<Data, NetworkServiceError>) -> Void) {

        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.wrongURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completionHandler(.failure(.init(error)))
                return
            }

            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {

                completionHandler(.failure(.wrongServerResponse))
                return
            }

            if let data = data {
                completionHandler(.success(data))
            } else {
                completionHandler(.failure(.noData))
            }
        }

        task.resume()
    }
}
