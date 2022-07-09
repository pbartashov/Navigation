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
    case missingPassword
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
                guard let delegate = loginDelegate else { return }
                
                do {
                    try delegate.checkAuthFor(login: login, password: password)
                    coordinator?.showProfile(for: login)
                    
                } catch LoginError.missingLogin {
                    state = .missingLogin
                    ErrorPresenter.shared.show(error: LoginError.missingLogin)
                    
                } catch LoginError.missingPassword {
                    state = .missingPassword
                    ErrorPresenter.shared.show(error: LoginError.missingPassword)
                    
                } catch {
                    state = .authFailed
                    ErrorPresenter.shared.show(error: error)
                }
                
            case .bruteForce:
                let randomPassword = Random.randomString(length: 4)
                bruteForceService?.start(passwordToUnlock: randomPassword)
                
            case .cancelBruteForce:
                bruteForceService?.cancel()
                
            case .startHintTimer:
                coordinator?.startHintTimer()
        }
    }
}
