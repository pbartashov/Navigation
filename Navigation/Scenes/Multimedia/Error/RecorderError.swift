//
//  RecorderError.swift
//  Navigation
//
//  Created by Павел Барташов on 16.07.2022.
//

import Foundation

enum RecorderError: Error {
    case noPermission
    case fileCreationError
}

extension RecorderError : LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .noPermission:
                return NSLocalizedString("Требуется разрешение на доступ к микрофону.", comment: "")
            case .fileCreationError:
                return NSLocalizedString("Ошибка при создании файла с записью.", comment: "")
        }
    }
}
