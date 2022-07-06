//
//  BruteForceServiceProtocol.swift
//  Navigation
//
//  Created by Павел Барташов on 03.07.2022.
//

import Foundation

enum BruteForceState {
    case success(password: String)
    case cancel
    case fail
}

protocol BruteForceServiceProtocol {
    var completion: ((BruteForceState) -> Void)? { get set }
    var progress: ((Int, String) -> Void)? { get set }

    func start(passwordToUnlock: String)
    func cancel()
}
