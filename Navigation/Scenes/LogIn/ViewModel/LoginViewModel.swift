//
//  LoginViewModel.swift
//  Navigation
//
//  Created by Павел Барташов on 30.06.2022.
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











enum LoginAction {
    case authWith(login: String, password: String)
}

enum LoginState {
    case initial
    case authFailed
}

protocol LoginViewModelProtocol: ViewModelProtocol
    where State == LoginState,
          Action == LoginAction {

}



final class LoginViewModel: ViewModel<LoginState, LoginAction>,
                            LoginViewModelProtocol {
    //MARK: - Properties

    weak var loginDelegate: LoginDelegate?
    weak var coordinator: LoginCoordinator?

    //MARK: - LifeCicle

    init(loginDelegate: LoginDelegate,
         coordinator: LoginCoordinator) {

        self.loginDelegate = loginDelegate
        self.coordinator = coordinator
        super.init(state: .initial)
    }

    //MARK: - Metods

    override func perfomAction(_ action: LoginAction) {
        switch action {
            case let .authWith(login: login, password: password):
                guard let delegate = loginDelegate else { return }

                if delegate.authPassedFor(login: login, password: password) {
                    coordinator?.showProfile(for: login)
                } else {
                    state = .authFailed
    
                }
            
        }
    }

}
