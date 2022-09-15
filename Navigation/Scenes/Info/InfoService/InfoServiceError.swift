//
//  InfoServiceError.swift
//  Navigation
//
//  Created by Павел Барташов on 31.07.2022.
//

import Foundation

enum InfoServiceError: Error {
    case commonError(description: String)
    case wrongJSON
    case missing(String)

    init(_ error: Error) {
        self = .commonError(description: error.localizedDescription)
    }
}

extension InfoServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .commonError(let description):
                return NSLocalizedString(description, comment: "")
                
            case .wrongJSON:
                return NSLocalizedString("Ошибка при декодировании данных с сервера", comment: "")

            case .missing(let property):
                return NSLocalizedString("В JSON отсутствует поле \(property)", comment: "")
        }
    }
}

