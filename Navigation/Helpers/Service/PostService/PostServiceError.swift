//
//  PostServiceError.swift
//  Navigation
//
//  Created by Павел Барташов on 08.07.2022.
//

import Foundation

enum PostServiceError: Error {
    case networkFailure
}

extension PostServiceError : LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .networkFailure:
                return NSLocalizedString("Отсутствует доступ в интернет.", comment: "")
        }
    }
}
