//
//  LoginViewModel.swift
//  Navigation
//
//  Created by Павел Барташов on 30.06.2022.
//

import Foundation

enum LoginAction {
    case authWith(login: String, password: String)
    case bruteForce
    case cancelBruteForce
    case startHintTimer
}

enum LoginState {
    case initial
    case missingLogin
    case wrongPassword
    case authFailed
    case bruteForceFinishedWith(password: String)
    case bruteForceCancelled
    case bruteForceProgress(password: String)
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
    var bruteForceService: BruteForceServiceProtocol?
    
    //MARK: - LifeCicle
    
    init(loginDelegate: LoginDelegate,
         coordinator: LoginCoordinator,
         bruteForceService: BruteForceServiceProtocol) {
        
        self.loginDelegate = loginDelegate
        self.coordinator = coordinator
        self.bruteForceService = bruteForceService
        super.init(state: .initial)
        
        setupBruteForceService()
    }
    
    //MARK: - Metods
    
    private func setupBruteForceService() {
        bruteForceService?.completion = { [weak self] bruteState in
            switch bruteState {
                case .success(password: let password):
                    self?.state = .bruteForceFinishedWith(password: password)
                    
                case .fail, .cancel:
                    self?.state = .bruteForceCancelled
            }
        }
        
        bruteForceService?.progress = { [weak self] counter, current in
            if counter % 100_000 == 0 {
                self?.state = .bruteForceProgress(password: current)
            }
        }
    }
    
    override func perfomAction(_ action: LoginAction) {
        switch action {
            case let .authWith(login: login, password: password):
                checkAuth(forLogin: login, password: password)
                
            case .bruteForce:
                let randomPassword = Random.randomString(length: 4)
                bruteForceService?.start(passwordToUnlock: randomPassword)
                
            case .cancelBruteForce:
                bruteForceService?.cancel()
                
            case .startHintTimer:
                coordinator?.startHintTimer()
        }
    }

    private func checkAuth(forLogin login: String, password: String) {
        loginDelegate?.checkCredentials(login: login, password: password) { [weak self] result in
            self?.handle(result: result, login: login, password: password)
        }
    }

    private func signUp(withLogin login: String, password: String) {
        coordinator?.showCreateAccount(for: login) { [weak self] in
            self?.loginDelegate?.signUp(login: login, password: password) { [weak self] result in
                self?.handle(result: result, login: login, password: password)
            }
        }
    }

    private func handle(result: Result<String, Error>,
                        login: String,
                        password:  String
    ) {
        switch result {
            case .failure(LoginError.missingLogin):
                handle(error: LoginError.missingLogin, state: .missingLogin)

            case .failure(LoginError.missingPassword):
                handle(error: LoginError.missingPassword, state: .wrongPassword)

            case .failure(LoginError.weakPassword):
                handle(error: LoginError.weakPassword, state: .wrongPassword)

            case .failure(LoginError.userNotFound):
                signUp(withLogin: login, password: password)
                
            case .failure(let error):
                handle(error: error, state: .authFailed)

            case.success(let userName):
                coordinator?.showProfile(for: userName)
        }
    }

    private func handle(error: Error, state: LoginState) {
        self.state = state
        ErrorPresenter.shared.show(error: error)
    }
}
