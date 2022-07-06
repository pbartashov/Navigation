//
//  ViewModel.swift
//  Navigation
//
//  Created by Павел Барташов on 03.07.2022.
//

protocol ViewModelProtocol {
    associatedtype State
    associatedtype Action

    var stateChanged: ((State) -> Void)? { get set }
    func perfomAction(_ action: Action)
}

class ViewModel<State, Action>: ViewModelProtocol {

    //MARK: - Properties

    var stateChanged: ((State) -> Void)?

    var state: State {
        didSet {
            stateChanged?(state)
        }
    }

    //MARK: - LifeCicle

    init(state: State) {
        self.state = state
    }

    //MARK: - Metods

    func perfomAction(_ action: Action) { }
}
