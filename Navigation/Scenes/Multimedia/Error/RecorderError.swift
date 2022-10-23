//
//  RecorderError.swift
//  Navigation
//
//  Created by Павел Барташов on 16.07.2022.
//

import Foundation

enum RecorderError: Error {
    case permissionDenied
    case fileCreationError
}

extension RecorderError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .permissionDenied:
                return "permissionDeniedRecorderError".localized
            case .fileCreationError:
                return "fileCreationErrorRecorderError".localized
        }
    }
}
