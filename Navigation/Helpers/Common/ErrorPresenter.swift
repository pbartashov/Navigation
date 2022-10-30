//
//  ErrorPresenter.swift
//  Navigation
//
//  Created by Павел Барташов on 09.07.2022.
//

import Foundation
import UIKit

protocol ErrorPresenterProtocol {
    func show(error: Error)
}

final class ErrorPresenter: ErrorPresenterProtocol {
    
    //MARK: - Properties
    
    static let shared = ErrorPresenter()
    
    private weak var presenter: UIViewController?
    
    private var errorQueue: [Error] = []
    private var isErrorPresenting = false
    
    //MARK: - LifeCicle
    
    private init() { }
    
    func initialize(with presenter: UIViewController) {
        self.presenter = presenter
    }
    
    //MARK: - Metods
    
    func show(error: Error) {
        guard presenter != nil else {
            preconditionFailure("ErrorPresenter not initialized")
        }
        
        DispatchQueue.main.async { [weak self] in
            if self?.isErrorPresenting == true {
                self?.errorQueue.append(error)
            } else {
                self?.isErrorPresenting = true
                
                let alert = UIAlertController(title: error.localizedDescription,
                                              message: nil,
                                              preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "okErrorPresenter".localized,
                                                 style: .default) { [weak self] _ in
                    self?.isErrorPresenting = false
                    if let nextError = self?.errorQueue.popLast() {
                        DispatchQueue.main.async {
                            self?.show(error: nextError)
                        }
                        
                    }
                }
                alert.addAction(cancelAction)
                
                self?.presenter?.present(alert, animated: true)
            }
        }
    }
}
