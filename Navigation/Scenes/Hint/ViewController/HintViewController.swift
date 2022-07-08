//
//  HintViewController.swift
//  Navigation
//
//  Created by Павел Барташов on 06.07.2022.
//

import UIKit

final class HintViewController<ViewModelType: HintViewModelProtocol>: UIViewController {

    //MARK: - Properties

    private var viewModel: ViewModelType

    //MARK: - Views

    private lazy var hintView: HintView = {
        let hintView = HintView()
        hintView.delegate = self

        return hintView
    }()

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

        view.addSubview(hintView)

        setupLayout()
        setupViewModel()
  }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.perfomAction(.startCountDown(with: 10))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        viewModel.perfomAction(.stopCountDown)
    }

    //MARK: - Metods

    func setupLayout() {
        hintView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setupViewModel() {
        viewModel.stateChanged = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .initial:
                        break
                    case .progress(let seconds):
                        self?.hintView.updateProgress(with: seconds)

                    case .updateHint(let hint):
                        if let hint = hint {
                            self?.hintView.updateHint(with: hint.value)
                            self?.hintView.updateButtons(with: hint.position)
                        }
                }
            }
        }
    }
}

// MARK: - ViewWithButtonDelegate methods
extension HintViewController: ViewWithButtonDelegate {
    func buttonTapped(sender: UIButton) {
        switch sender.tag {
            case HintView.Buttons.previous.hashValue:
                viewModel.perfomAction(.backward)

            case HintView.Buttons.close.hashValue:
                viewModel.perfomAction(.closeHint)

            case HintView.Buttons.next.hashValue:
                viewModel.perfomAction(.forward)

            default:
                break
        }
    }
}
