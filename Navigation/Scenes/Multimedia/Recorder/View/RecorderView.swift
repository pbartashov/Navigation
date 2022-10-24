//
//  RecorderView.swift
//  Navigation
//
//  Created by Павел Барташов on 16.07.2022.
//

import UIKit
final class RecorderView: UIView {

    enum Buttons: String {
        case recordOrPause = "mic.fill"
        case clearOrStop = "xmark.circle.fill"
        case playOrPause = "play.fill"
        case stopPlaying = "stop.fill"
    }

    //MARK: - Properties

    weak var delegate: ViewWithButtonDelegate?

    //MARK: - Views

    private let logoImageView: UIImageView =  {
        let config = UIImage.SymbolConfiguration(pointSize: 72)
        let image = UIImage(systemName: "waveform.and.mic", withConfiguration: config)
        let imageView = UIImageView(image: image)

        return imageView
    }()

    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }()

    private lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 3 * Constants.padding

        return stack
    }()

    private lazy var recordOrPauseButton: UIButton = {
        RecordFactory().createButton(imageSystemNameForNormal: Buttons.recordOrPause.rawValue,
                                     imageSystemNameForSelected: "pause.fill",
                                     buttonType: Buttons.recordOrPause,
                                     buttonImageColor: .black,
                                     delegate: delegate)
    }()

    private lazy var clearOrStopRecordingButton: UIButton = {
        RecordFactory().createButton(imageSystemNameForNormal: Buttons.clearOrStop.rawValue,
                                     imageSystemNameForSelected: "stop.fill",
                                     buttonType: Buttons.clearOrStop,
                                     buttonImageColor: .black,
                                     delegate: delegate)
    }()

    private lazy var playOrPauseButton: UIButton = {
        RecordFactory().createButton(imageSystemNameForNormal: Buttons.playOrPause.rawValue,
                                     imageSystemNameForSelected: "pause.fill",
                                     buttonType: Buttons.playOrPause,
                                     delegate: delegate)
    }()

    private lazy var stopPlayingButton: UIButton = {
        RecordFactory().createButton(imageSystemNameForNormal: Buttons.stopPlaying.rawValue,
                                     buttonType: Buttons.stopPlaying,
                                     delegate: delegate)
    }()

    //MARK: - LifeCicle

    init(delegate: ViewWithButtonDelegate?) {
        self.delegate = delegate
        super.init(frame: .zero)

        initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Metods

    private func initialize() {
        addSubview(mainStack)

        let recordButtonStack = UIStackView()
        recordButtonStack.spacing = 3 * Constants.padding
        recordButtonStack.alignment = .center

        let playButtonStack = UIStackView()
        playButtonStack.spacing = 3 * Constants.padding
        playButtonStack.alignment = .center

        [recordOrPauseButton,
         clearOrStopRecordingButton,
        ].forEach {
            recordButtonStack.addArrangedSubview($0)
        }

        [playOrPauseButton,
         stopPlayingButton,
        ].forEach {
            playButtonStack.addArrangedSubview($0)
        }

        [recordButtonStack,
         statusLabel,
         playButtonStack,
        ].forEach {
            self.mainStack.addArrangedSubview($0)
        }

        setupLayouts()
    }

    private func setupLayouts() {
        mainStack.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(Constants.padding)
            make.trailing.equalToSuperview().offset(-Constants.padding)
        }

        logoImageView.snp.makeConstraints { make in
            make.height.equalTo(logoImageView.snp.width)
        }
    }

    func updateState(with state: RecorderState) {
        statusLabel.text = state.title
        
        resetButtons(isEnabled: false)

        switch state {
            case .empty:
                recordOrPauseButton.enable()

            case .permissionDenied:
                break

            case .stopped:
                recordOrPauseButton.enable()
                clearOrStopRecordingButton.enable()
                playOrPauseButton.enable()
                stopPlayingButton.enable()

            case .recording:
                recordOrPauseButton.enable()
                clearOrStopRecordingButton.enable()
                recordOrPauseButton.select()
                clearOrStopRecordingButton.select()

            case .recordingPaused:
                recordOrPauseButton.enable()
                clearOrStopRecordingButton.enable()
                clearOrStopRecordingButton.select()

            case .playing:
                playOrPauseButton.enable()
                stopPlayingButton.enable()
                playOrPauseButton.select()

            case .playingPaused:
                playOrPauseButton.enable()
                stopPlayingButton.enable()
        }
    }

    private func resetButtons(isEnabled: Bool) {
        recordOrPauseButton.isEnabled = isEnabled
        clearOrStopRecordingButton.isEnabled = isEnabled
        playOrPauseButton.isEnabled = isEnabled
        stopPlayingButton.isEnabled = isEnabled

        recordOrPauseButton.isSelected = false
        clearOrStopRecordingButton.isSelected = false
        playOrPauseButton.isSelected = false
    }
}
