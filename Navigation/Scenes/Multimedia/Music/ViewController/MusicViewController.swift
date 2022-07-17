//
//  MisicViewController.swift
//  Navigation
//
//  Created by Павел Барташов on 12.07.2022.
//

import UIKit

final class MusicViewController<ViewModelType: MusicViewModelProtocol>: UIViewController {

    //MARK: - Properties

    private var viewModel: ViewModelType

    //MARK: - Views

    private lazy var musicView = MusicView(delegate: self)

    //MARK: - LifeCicle

    init(viewModel: ViewModelType) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(musicView)
        view.backgroundColor = .white

        setupLayout()
        setupViewModel()

        viewModel.perfomAction(.reset)
    }

    //MARK: - Metods

    func setupLayout() {
        musicView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setupViewModel() {
        viewModel.stateChanged = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .loaded(let track):
                        if let track = track {
                            self?.musicView.updateTrack(with: track.value)
                            self?.musicView.updateGoButtons(with: track.position)
                        }

                    case .playing, .paused, .stopped:
                        self?.musicView.updatePlayBackButtons(with: state)

                }
            }
        }
    }
}

// MARK: - ViewWithButtonDelegate methods
extension MusicViewController: ViewWithButtonDelegate {
    func buttonTapped(sender: UIButton) {
        switch sender.tag {
            case MusicView.Buttons.previous.hashValue:
                viewModel.perfomAction(.backward)

            case MusicView.Buttons.play.hashValue:
                viewModel.perfomAction(.play)

            case MusicView.Buttons.pause.hashValue:
                viewModel.perfomAction(.pause)

            case MusicView.Buttons.stop.hashValue:
                viewModel.perfomAction(.stop)

            case MusicView.Buttons.next.hashValue:
                viewModel.perfomAction(.forward)

            default:
                break
        }
    }
}
