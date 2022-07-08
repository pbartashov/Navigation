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
    case updateHint(with: HintElement)
}

protocol HintViewModelProtocol: ViewModelProtocol
    where State == HintState,
          Action == HintAction {
}

final class HintViewModel: ViewModel<HintState, HintAction>,
                           HintViewModelProtocol {
    //MARK: - Properties

    weak var coordinator: NavigationCoordinator?

    private var model = HintModel()

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
                startTime = seconds
                resetCounter()

                if let first = model.first {
                    self.state = .updateHint(with: first)
                }

                let timer = Timer(timeInterval: speed, repeats: true) { [weak self] _ in
                    guard let self = self else { return }

                    self.counter -= self.speed
                    self.state = .progress(self.counter)

                    if self.counter <= 0.0 {
                        if let next = self.model.next() {
                            self.state = .updateHint(with: next)
                        } else {
                            self.model.reset()
                            if let first = self.model.first {
                                self.state = .updateHint(with: first)
                            }
                        }

                        self.resetCounter()
                    }
                }

                RunLoop.current.add(timer, forMode: .common)
                self.timer = timer

            case .closeHint:
                coordinator?.dismiss(animated: true)
                fallthrough
                
            case .stopCountDown:
                timer?.invalidate()
                timer = nil

            case .backward:
                if let previous = self.model.previous() {
                    self.state = .updateHint(with: previous)
                }
                resetCounter()

            case .forward:
                if let next = self.model.next() {
                    self.state = .updateHint(with: next)
                }
                resetCounter()
        }
    }

    private func resetCounter() {
        counter = startTime
        state = .progress(counter)
    }
}

