//
//  MusicError.swift
//  Navigation
//
//  Created by Павел Барташов on 14.07.2022.
//

import Foundation

enum MusicError: Error {
    case trackNotFound
}

extension MusicError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .trackNotFound:
                return "trackNotFoundMusicError".localized
        }
    }
}
