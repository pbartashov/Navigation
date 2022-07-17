//
//  HintViewModel.swift
//  Navigation
//
//  Created by Павел Барташов on 06.07.2022.
//

import Foundation

enum HintAction {
    case startCountDown(with: TimeInterval)
    case stopCountDown
    case closeHint
    case backward
    case forward
}

enum HintState {
    case initial
    case progress(TimeInterval)
    case updateHint(with: HintElement?)
}

protocol HintViewModelProtocol: ViewModelProtocol
where State == HintState,
      Action == HintAction {
}

final class HintViewModel: ViewModel<HintState, HintAction>,
                           HintViewModelProtocol {
    //MARK: - Properties

    weak var coordinator: NavigationCoordinator?

    private var model = HintModel(collection: HintModel.demoHints)

    private weak var timer: Timer?
    private var counter: TimeInterval = 0.0
    private var speed: TimeInterval = 1.0
    private var startTime: TimeInterval = 0.0

    //MARK: - LifeCicle

    init(coordinator: NavigationCoordinator) {
        self.coordinator = coordinator
        super.init(state: .initial)
    }

    //MARK: - Metods

    override func perfomAction(_ action: HintAction) {
        switch action {
            case .startCountDown(let seconds):
                startTimer(seconds)

            case .closeHint:
                coordinator?.dismiss(animated: true)
                fallthrough
                
            case .stopCountDown:
                stopTimer()

            case .backward:
                state = .updateHint(with: model.previous())
                resetCounter()

            case .forward:
                state = .updateHint(with: model.next())
                resetCounter()
        }
    }

    private func startTimer(_ seconds: TimeInterval) {
        startTime = seconds
        resetCounter()

        state = .updateHint(with: model.first)

        timer = Timer.scheduledTimer(withTimeInterval: speed, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            self.counter -= self.speed
            self.state = .progress(self.counter)

            if self.counter <= 0.0 {
                let next = self.model.next()

                if next == nil {
                    self.model.reset()
                    self.state = .updateHint(with: self.model.first)
                } else {
                    self.state = .updateHint(with: next)
                }

                self.resetCounter()
            }
        }
    }

    private func resetCounter() {
        counter = startTime
        state = .progress(counter)
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
