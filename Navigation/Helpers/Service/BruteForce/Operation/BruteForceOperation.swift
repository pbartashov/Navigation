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
            printDescription(for: "cancelled", at: Date())
            return
        }

        var password = ""
        bruteForcer.reset()

        let startTime = Date()
        printDescription(for: "started", at: startTime)

        var counter = 0

        while password != passwordToUnlock { // Increase MAXIMUM_PASSWORD_SIZE value for more
            if isCancelled {
                printDescription(for: "cancelled", at: Date())
                return
            }

            password = bruteForcer.generateBruteForce(password)

            if lengthLimit > 0 && password.count > lengthLimit {
                printDescription(for: "failed", at: Date())
                return
            }

            password.append(suffix)

            progress?(counter, password)
            counter += 1
        }

        let endTime = Date()
        printDescription(for: "finished", at: endTime)

        let duration = String(format: "%.2f", endTime.timeIntervalSince(startTime))
        print("duration: \(duration)")
        print("password: \(password)")

        result = password
    }

    private func printDescription(for action: String, at date: Date) {
        if lengthLimit > 0 {
            var template = ""
            for _ in 0..<lengthLimit {
                template.append("?")
            }

            print("\(passwordToUnlock) with template \(template)\(suffix) \(action) at: \(date)")
        } else {
            print("\(passwordToUnlock) \(action) at: \(date)")
        }
    }
}
