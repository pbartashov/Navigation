//
//  MusicViewModel.swift
//  Navigation
//
//  Created by Павел Барташов on 14.07.2022.
//

import Foundation

enum MusicAction {
    case playOrPause
    case stop
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
        player.onFinishPlaying = { [weak self] successfully in
            if successfully, let next = self?.storage.next() {
                self?.state = .loaded(track: next)
                self?.play(next)
            } else {
                self?.state = .stopped
            }
        }
    }

    override func perfomAction(_ action: MusicAction) {
        switch action {
            case .playOrPause:
                if player.isPlaying {
                    player.pause()
                    state = .paused
                } else if player.isPaused {
                    player.play()
                    state = .playing
                } else {
                    play(storage.current)
                }

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
