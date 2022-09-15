//
//  BruteForceOperation.swift
//  Navigation
//
//  Created by Павел Барташов on 03.07.2022.
//

import Foundation

final class BruteForceOperation: Operation {

    //MARK: - Properties

    var bruteForcer: BruteForcerProtocol

    var passwordToUnlock: String

    var allowedCharacters: String = String().printable
    var progress: ((Int, String) -> Void)?
    var result: String = ""

    var lengthLimit = 0 // ноль означает, что длина подбираемой части пароля неограничена
    var suffix = ""

    //MARK: - LifeCicle

    init(passwordToUnlock: String,
         bruteForcer: BruteForcerProtocol) {

        self.passwordToUnlock = passwordToUnlock
        self.bruteForcer = bruteForcer
    }

    //MARK: - Metods

    override func main() {
        if isCancelled {
            Print.description(of: self, for: "cancelled")
            return
        }

        var password = ""
        bruteForcer.reset()

        let startTime = Date()
        Print.description(of: self, for: "started", at: startTime)

        var counter = 0

        while password != passwordToUnlock { // Increase MAXIMUM_PASSWORD_SIZE value for more
            if isCancelled {

                Print.description(of: self, for: "cancelled")
                return
            }

            password = bruteForcer.generateBruteForce(password)

            if lengthLimit > 0 && password.count > lengthLimit {
                Print.description(of: self, for: "failed")
                return
            }

            password.append(suffix)

            progress?(counter, password)
            counter += 1
        }

        let endTime = Date()
        Print.description(of: self, for: "finished", at: endTime)
        Print.bruteForcePasswordDuration(from: startTime, till: endTime, for: password)

        result = password
    }
}
