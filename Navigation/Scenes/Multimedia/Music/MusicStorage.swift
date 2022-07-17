//
//  MusicStorage.swift
//  Navigation
//
//  Created by Павел Барташов on 12.07.2022.
//

import Foundation

typealias MusicTrackElement = (value: MusicTrack, position: CollectionPosition)

typealias MusicStorage = IterableCollection<MusicTrack>

extension MusicStorage {
    static var demoMusicTracks: [MusicTrack] { [
        MusicTrack(artist: "Rory Gallagher",
                   title: "Bad Penny",
                   fileName: "38367",
                   fileType: "mp3"),

        MusicTrack(artist: "Don Fardon",
                   title: "I'm Alive",
                   fileName: "f3cf9c52dcde49b9de8679ebf220d3be5fc4c2c7b805e07a6049de91d0a19399",
                   fileType: "mp3"),

        MusicTrack(artist: "Dual Sessions",
                   title: "Radioactive",
                   fileName: "25915",
                   fileType: "mp3"),

        MusicTrack(artist: "AC/DC",
                   title: "T.N.T.",
                   fileName: "33535",
                   fileType: "mp3"),

        MusicTrack(artist: "Tom Petty And The Heartbreakers",
                   title: "Mary Jane's Last Dance",
                   fileName: "42671",
                   fileType: "mp3")
    ] }
}
