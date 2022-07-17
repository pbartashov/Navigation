//
//  RecorderConstants.swift
//  Navigation
//
//  Created by Павел Барташов on 17.07.2022.
//

import Foundation

enum RecorderConstants {
    static var audioRecordFileName: String {
        "record.m4a"
    }

    static func getAudioFilename() throws -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        guard !paths.isEmpty else { throw RecorderError.fileCreationError }

        return paths[0].appendingPathComponent(audioRecordFileName)
    }
}
