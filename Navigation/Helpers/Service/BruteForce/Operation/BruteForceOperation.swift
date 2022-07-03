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

    //MARK: - LifeCicle

    init(passwordToUnlock: String,
         bruteForcer: BruteForcerProtocol) {

        self.passwordToUnlock = passwordToUnlock
        self.bruteForcer = bruteForcer
    }

    //MARK: - Metods

    override func main() {
        if isCancelled {
            print("\(passwordToUnlock) cancelled at: \(Date())")
            return
        }

        var password = ""
        bruteForcer.reset()

        let startTime = Date()
        print("\(passwordToUnlock) started at: \(startTime)")

        var counter = 0

        while password != passwordToUnlock { // Increase MAXIMUM_PASSWORD_SIZE value for more
            if isCancelled {
                print("\(passwordToUnlock) cancelled at: \(Date())")
                return
            }

            password = bruteForcer.generateBruteForce(password)

            progress?(counter, password)
            counter += 1
        }

        let endTime = Date()
        print("\(passwordToUnlock) finished at: \(endTime)")

        let duration = String(format: "%.2f", endTime.timeIntervalSince(startTime))
        print("duration: \(duration)")
        print("password: \(password)")

        result = password
    }
}
