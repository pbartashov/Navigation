//
//  InfoService.swift
//  Navigation
//
//  Created by Павел Барташов on 31.07.2022.
//

import Foundation

struct InfoService {

    // MARK: - Properties

    private let networkService = NetworkService()
    private let urlString = "https://jsonplaceholder.typicode.com/todos/8"

    // MARK: - Metods

    func getData(comletion: @escaping (Result<InfoModel, InfoServiceError>) -> Void) {
        networkService.request(with: urlString) { result in
            switch result {
                case .success(let data):
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: data)

                        guard let json = jsonObject as? [String : Any] else {
                            comletion(.failure(.wrongJSON))
                            return
                        }

                        guard let userId = json["userId"] as? Int else {
                            comletion(.failure(.missing("userId")))
                            return
                        }

                        guard let id = json["id"] as? Int else {
                            comletion(.failure(.missing("id")))
                            return
                        }

                        guard let title = json["title"] as? String else {
                            comletion(.failure(.missing("title")))
                            return
                        }

                        guard let completed = json["completed"] as? Bool else {
                            comletion(.failure(.missing("completed")))
                            return
                        }

                        let infoModel = InfoModel(userId: userId,
                                                  id: id,
                                                  title: title,
                                                  completed: completed)

                        comletion(.success(infoModel))

                    } catch {
                        comletion(.failure(.init(error)))
                    }

                case .failure(let error):
                    comletion(.failure(.init(error)))
            }
        }
    }
}
