//
//  MusicViewModel.swift
//  Navigation
//
//  Created by Павел Барташов on 12.07.2022.
//

import Foundation

enum MusicAction {
    case play
    case stop
    case pause
    case backward
    case forward
    case reset
}

enum MusicState {
    case loaded(track: MusicTrackElement?)
    case playing
    case paused
    case stopped
}

protocol MusicViewModelProtocol: ViewModelProtocol
where State == MusicState,
      Action == MusicAction {
}

final class MusicViewModel: ViewModel<MusicState, MusicAction>,
                            MusicViewModelProtocol {
    //MARK: - Properties

    private var storage: MusicStorage
    private var player: MusicPlayer

    //MARK: - LifeCicle

    init(storage: MusicStorage,
         player: MusicPlayer) {

        self.storage = storage
        self.player = player

        super.init(state: .stopped)

        setupPlayer()
    }

    //MARK: - Metods

    private func setupPlayer() {
        player.onFinishPlaying = { [weak self] _ in
            let next = self?.storage.next()
            self?.state = .loaded(track: next)
            self?.play(next)
        }
    }

    override func perfomAction(_ action: MusicAction) {
        switch action {
            case .play:
                play(storage.current)

            case .pause:
                player.pause()
                state = .paused

            case .stop:
                stop()

            case .backward:
                switchTrack(to: storage.previous())

            case .forward: ()
                switchTrack(to: storage.next())

            case .reset:
                storage.reset()
                state = .loaded(track: storage.current)
                state = .stopped
        }
    }

    private func play(_ track: MusicTrackElement?) {
        do {
            try player.play(track?.value)
            state = .playing
        } catch {
            stop()
            ErrorPresenter.shared.show(error: error)
        }
    }

    private func switchTrack(to track: MusicTrackElement?) {
        if player.isPlaying {
            play(track)
        } else {
            stop()
        }

        state = .loaded(track: track)
    }

    private func stop() {
        player.stop()
        state = .stopped
    }
}
