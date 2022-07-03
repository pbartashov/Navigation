//
//  BruteForceService.swift
//  Navigation
//
//  Created by Павел Барташов on 29.06.2022.
//

import Foundation

final class BruteForceService: BruteForceServiceProtocol {

    //MARK: - Properties

    private var bruteWorkItem: DispatchWorkItem?

    private var result: String = ""

    var queue = DispatchQueue.global(qos: .userInitiated)

    var allowedCharacters: [String] = String().printable.map { String($0) }

    var completion: ((BruteForceState) -> Void)?
    var progress: ((Int, String) -> Void)?

    //MARK: - Metods

    private func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character))!
    }

    private func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index])
        : Character("")
    }

    //https://github.com/netology-code/iosint-homeworks/blob/iosint-3/6/Brut%20Force.zip
    private func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var str: String = string

        if str.count <= 0 {
            str.append(characterAt(index: 0, array))
        }
        else {
            str.replace(at: str.count - 1,
                        with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))

            if indexOf(character: str.last!, array) == 0 {
                str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
            }
        }

        return str
    }

    private func bruteForce(passwordToUnlock: String) {
        var password = ""

        let startTime = Date()
        print("\(passwordToUnlock) started at: \(startTime)")

        var counter = 0

        // Will strangely ends at 0000 instead of ~~~
        while password != passwordToUnlock { // Increase MAXIMUM_PASSWORD_SIZE value for more
            guard let bruteWorkItem = bruteWorkItem, !bruteWorkItem.isCancelled else {
                print("\(passwordToUnlock) cancelled at: \(Date())")
                return
            }

            password = generateBruteForce(password, fromArray: allowedCharacters)

            progress?(counter, password)
            counter += 1
            // Your stuff here
            //            print("\(passwordToUnlock) -> \(password)")
            // Your stuff here
        }

        let endTime = Date()
        print("\(passwordToUnlock) finished at: \(endTime)")

        let duration = String(format: "%.2f", endTime.timeIntervalSince(startTime))
        print("duration: \(duration)")
        print("password: \(password)")

        result = password
    }

    func start(passwordToUnlock: String) {
        bruteWorkItem?.cancel()

        let newBruteWorkItem = DispatchWorkItem {
            self.bruteForce(passwordToUnlock: passwordToUnlock)
        }

        newBruteWorkItem.notify(queue: DispatchQueue.global(qos: .userInitiated)) { [weak self] in
            guard let self = self else { return }

            guard let bruteWorkItem = self.bruteWorkItem, !bruteWorkItem.isCancelled else {
                self.completion?(.cancel)
                return
            }

            if self.result.isEmpty {
                self.completion?(.fail)
            } else {
                self.completion?(.success(password: self.result))
            }

            self.bruteWorkItem = nil
        }

        bruteWorkItem = newBruteWorkItem

        result = ""
        queue.async(execute: newBruteWorkItem)
    }

    func cancel() {
        bruteWorkItem?.cancel()
        bruteWorkItem = nil
    }
}
