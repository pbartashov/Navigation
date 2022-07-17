//
//  MusicView.swift
//  Navigation
//
//  Created by Павел Барташов on 12.07.2022.
//

import UIKit

final class MusicView: UIView {

    enum Buttons: String {
        case play = "play.fill"
        case pause = "pause.fill"
        case stop = "stop.fill"
        case previous = "chevron.backward.2"
        case next = "chevron.forward.2"
    }

    //MARK: - Properties

    weak var delegate: ViewWithButtonDelegate?

    //MARK: - Views

    private let logoImageView: UIImageView =  {
        let config = UIImage.SymbolConfiguration(pointSize: 72)
        let image = UIImage(systemName: "music.note.list", withConfiguration: config)
        let imageView = UIImageView(image: image)

        return imageView
    }()

    private lazy var artistLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30)
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }()

    private lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 2 * Constants.padding

        return stack
    }()

    private lazy var previousButton: UIButton = {
        MusicFactory().createButton(imageSystemNameForNormal: Buttons.previous.rawValue,
                                    buttonType: Buttons.previous,
                                    buttonImageColor: .black,
                                    delegate: delegate)
    }()

    private lazy var nextButton: UIButton = {
        MusicFactory().createButton(imageSystemNameForNormal: Buttons.next.rawValue,
                                    buttonType: Buttons.next,
                                    buttonImageColor: .black,
                                    delegate: delegate)
    }()

    private lazy var playButton: UIButton = {
        MusicFactory().createButton(imageSystemNameForNormal: Buttons.play.rawValue,
                                    buttonType: Buttons.play,
                                    delegate: delegate)
    }()

    private lazy var pauseButton: UIButton = {
        MusicFactory().createButton(imageSystemNameForNormal: Buttons.pause.rawValue,
                                    buttonType: Buttons.pause,
                                    delegate: delegate)
    }()

    private lazy var stopButton: UIButton = {
        MusicFactory().createButton(imageSystemNameForNormal: Buttons.stop.rawValue,
                                    buttonType: Buttons.stop,
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

        let buttonStack = UIStackView()
        buttonStack.spacing = 36
        buttonStack.alignment = .center

        [previousButton,
         playButton,
         pauseButton,
         stopButton,
         nextButton
        ].forEach {
            buttonStack.addArrangedSubview($0)
        }

        [logoImageView,
         artistLabel,
         titleLabel,
         buttonStack
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

    func updateTrack(with musicTrack: MusicTrack) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.artistLabel.alpha = 0
            self?.titleLabel.alpha = 0
        } completion: { [weak self] _ in
            self?.artistLabel.text = musicTrack.artist
            self?.titleLabel.text = musicTrack.title

            UIView.animate(withDuration: 0.3) {
                self?.artistLabel.alpha = 1
                self?.titleLabel.alpha = 1
            }
        }
    }

    func updateGoButtons(with position: CollectionPosition) {
        switch position {
            case .first:
                previousButton.isEnabled = false
                nextButton.isEnabled = true

            case .middle:
                previousButton.showWithAnimation()
                previousButton.isEnabled = true
                nextButton.isEnabled = true

            case .last:
                previousButton.showWithAnimation()
                previousButton.isEnabled = true
                nextButton.isEnabled = false
        }
    }

    func updatePlayBackButtons(with state: MusicState) {
        switch state {
            case .playing:
                playButton.isEnabled = false
                pauseButton.isEnabled = true
                stopButton.isEnabled = true

            case .paused:
                playButton.isEnabled = false
                pauseButton.isEnabled = true
                stopButton.isEnabled = true
                
            case .stopped:
                playButton.isEnabled = true
                pauseButton.isEnabled = false
                stopButton.isEnabled = false

            case .loaded:
                break
        }
    }
}
