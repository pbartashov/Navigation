//
//  AudioRecorder.swift
//  Navigation
//
//  Created by Павел Барташов on 17.07.2022.
//

import AVFoundation

final class AudioRecorder: NSObject {

    //MARK: - Properties

    private var recorder: AVAudioRecorder?
    var onFinishRecording: ((Bool) -> Void)?

    var isRecording: Bool {
        recorder?.isRecording == true
    }

    //MARK: - Metods

    //https://www.hackingwithswift.com/example-code/media/how-to-record-audio-using-avaudiorecorder
    func start() throws {
        let audioFilename = try RecorderConstants.getAudioFilename()

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        recorder = try AVAudioRecorder(url: audioFilename, settings: settings)
        recorder?.delegate = self
        recorder?.record()
    }

    func pause() {
        if isRecording {
            recorder?.pause()
        } else {
            recorder?.record()
        }
    }

    func stop() {
        recorder?.stop()
        recorder = nil
    }
}

// MARK: - AVAudioRecorder methods
extension AudioRecorder: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        onFinishRecording?(flag)

        if !flag {
            stop()
        }
    }
}
