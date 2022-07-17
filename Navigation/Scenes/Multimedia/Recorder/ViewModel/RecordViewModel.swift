//
//  RecordViewModel.swift
//  Navigation
//
//  Created by Павел Барташов on 17.07.2022.
//

import AVFoundation

enum RecorderAction {
    case requstPlayAndRecordPermission

    case startOrPauseRecording
    case clearOrStopRecording
    case startOrPausePlaying
    case stopPlaying
}

enum RecorderState: String {
    case permissionDenied = "Нет разрешения на использование микрофона"

    case empty = "Записи пока нет"

    case recording = "Идет запись..."
    case recordingPaused = "Запись на паузе"

    case playing = "Воспроизведение..."
    case playingPaused = "Воспроизведение на паузе"

    case stopped = "Стоп"
}

protocol RecorderViewModelProtocol: ViewModelProtocol
where State == RecorderState,
      Action == RecorderAction {
}

final class RecorderViewModel: ViewModel<RecorderState, RecorderAction>,
                               RecorderViewModelProtocol {
    //MARK: - Properties

    private let recorder: AudioRecorder
    private let player: MusicPlayer
    private let recordingSession: AVAudioSession

    //MARK: - LifeCicle

    init(recorder: AudioRecorder,
         player: MusicPlayer) {

        self.recorder = recorder
        self.player = player
        self.recordingSession = AVAudioSession.sharedInstance()

        super.init(state: .permissionDenied)

        setupPlayer()
        setupRecorder()
    }

    //MARK: - Metods

    private func setupPlayer() {
        player.onFinishPlaying = { [weak self] _ in
            self?.state = .stopped
        }
    }

    private func setupRecorder() {
        recorder.onFinishRecording = { [weak self] successfully in
            if successfully {
                self?.state = .stopped
            } else {
                self?.state = .empty
            }
        }
    }

    override func perfomAction(_ action: RecorderAction) {
        switch action {
            case .requstPlayAndRecordPermission:
                requestPerimission()

            case .startOrPauseRecording:
                if state == .stopped || state == .empty {
                    startRecording()
                } else {
                    pauseRecording()
                }

            case .clearOrStopRecording:
                if state == .recording || state == .recordingPaused {
                    stopRecording()
                } else {
                    state = .empty
                }

            case .startOrPausePlaying:
                if state == .stopped {
                    startPlaying()
                } else {
                    pausePlaying()
                }

            case .stopPlaying:
                stopPlaying()
        }
    }

    private func requestPerimission() {
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [weak self] allowed in
                if allowed {
                    self?.state = .empty
                } else {
                    self?.state = .permissionDenied
                    ErrorPresenter.shared.show(error: RecorderError.noPermission)
                }
            }
        } catch {
            ErrorPresenter.shared.show(error: error)
        }
    }

    //https://www.hackingwithswift.com/example-code/media/how-to-record-audio-using-avaudiorecorder
    private func startRecording() {
        do {
            try recorder.start()
            state = .recording
        } catch {
            stopRecording()
            ErrorPresenter.shared.show(error: error)
        }
    }

    private func pauseRecording() {
        recorder.pause()
        state = recorder.isRecording ? .recording : .recordingPaused
    }

    private func stopRecording() {
        recorder.stop()
        state = .stopped
    }

    private func startPlaying() {
        do {
            try player.play(RecorderConstants.getAudioFilename())
            state = .playing
        } catch {
            stopPlaying()
            ErrorPresenter.shared.show(error: error)
        }
    }

    private func pausePlaying() {
        player.pause()
        state = player.isPlaying ? .playing : .playingPaused
    }
    
    private func stopPlaying() {
        player.stop()
        state = .stopped
    }
}

