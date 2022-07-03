//
//  BruteForcerProtocol.swift
//  Navigation
//
//  Created by Павел Барташов on 03.07.2022.
//

import Foundation

protocol BruteForcerProtocol {
    mutating func generateBruteForce(_ password: String) -> String
    mutating func reset()
}

extension BruteForcerProtocol {
    func reset() { }
}
