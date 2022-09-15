//
//  RecorderViewController.swift
//  Navigation
//
//  Created by Павел Барташов on 17.07.2022.
//

import UIKit

final class RecorderViewController<ViewModelType: RecorderViewModelProtocol>: UIViewController {

    // MARK: - Properties

    private var viewModel: ViewModelType

    // MARK: - Views

    private lazy var recorderView = RecorderView(delegate: self)

    // MARK: - LifeCicle

    init(viewModel: ViewModelType) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.perfomAction(.requstPlayAndRecordPermission)
    }

    //MARK: - Metods

    private func initialize() {
        view.backgroundColor = .white
        view.addSubview(recorderView)

        setupLayout()
        setupViewModel()
    }

    private func setupLayout() {
        recorderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupViewModel() {
        viewModel.stateChanged = { [weak self] state in
            DispatchQueue.main.async {
                self?.recorderView.updateState(with: state)
            }
        }
    }
}

// MARK: - ViewWithButtonDelegate methods
extension RecorderViewController: ViewWithButtonDelegate {
    func buttonTapped(sender: UIButton) {
        switch sender.tag {
            case RecorderView.Buttons.recordOrPause.hashValue:
                viewModel.perfomAction(.startOrPauseRecording)

            case RecorderView.Buttons.clearOrStop.hashValue:
                viewModel.perfomAction(.clearOrStopRecording)

            case RecorderView.Buttons.playOrPause.hashValue:
                viewModel.perfomAction(.startOrPausePlaying)

            case RecorderView.Buttons.stopPlaying.hashValue:
                viewModel.perfomAction(.stopPlaying)

            default:
                break
        }
    }
}
