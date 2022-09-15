//
//  NetworkServiceError.swift
//  Navigation
//
//  Created by Павел Барташов on 31.07.2022.
//

import Foundation

enum NetworkServiceError: Error {
    case commonError(description: String)
    case wrongURL
    case wrongServerResponse
    case noData

    init(_ error: Error) {
        self = .commonError(description: error.localizedDescription)
    }
}

extension NetworkServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .wrongURL:
                return NSLocalizedString("Неверный URL.", comment: "")

            case .wrongServerResponse:
                return NSLocalizedString("Неверный ответ от сервера.", comment: "")

            case .noData:
                return NSLocalizedString("Нет данных от сервера.", comment: "")

            case .commonError(let description):
                return NSLocalizedString(description, comment: "")
        }
    }
}
