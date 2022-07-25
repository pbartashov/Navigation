//
//  MusicPlayer.swift
//  Navigation
//
//  Created by Павел Барташов on 12.07.2022.
//

import AVFoundation

final class MusicPlayer: NSObject {

    //MARK: - Properties

    private var player: AVAudioPlayer?
    var onFinishPlaying: ((Bool) -> Void)?

    var isPlaying: Bool {
        player?.isPlaying == true
    }

    var isPaused: Bool {
        !(player == nil || isPlaying)
    }

    //MARK: - Metods

    func play(_ track: MusicTrack?) throws {
        guard let track = track else { return }

        let url = Bundle.main.url(forResource: track.fileName,
                                  withExtension: track.fileType)
        guard let url = url else { throw MusicError.trackNotFound }

        try play(url)
    }

    func play(_ url: URL) throws {
        player = try AVAudioPlayer(contentsOf: url)
        player?.delegate = self
        player?.prepareToPlay()
        player?.play()
    }

    func pause() {
        player?.pause()
    }

    func play() {
        player?.play()
    }

    func stop() {
        player?.stop()
        player = nil
    }
}

// MARK: - AVAudioPlayerDelegate methods
extension MusicPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        onFinishPlaying?(flag)

        if !flag {
            stop()
        }
    }
}
