//
//  BruteForceService.swift
//  Navigation
//
//  Created by Павел Барташов on 29.06.2022.
//

import Foundation

final class GCDBruteForceService: BruteForceServiceProtocol {

    //MARK: - Properties

    var bruteForcer: BruteForcerProtocol

    private var bruteWorkItem: DispatchWorkItem?

    private var result: String = ""

    var queue = DispatchQueue.global(qos: .userInitiated)

    var completion: ((BruteForceState) -> Void)?
    var progress: ((Int, String) -> Void)?

    //MARK: - LifeCicle

    init(bruteForcer: BruteForcerProtocol) {
        self.bruteForcer = bruteForcer
    }

    //MARK: - Metods

    private func bruteForce(passwordToUnlock: String) {
        var password = ""
        bruteForcer.reset()

        let startTime = Date()
        print("\(passwordToUnlock) started at: \(startTime)")

        var counter = 0

        while password != passwordToUnlock { // Increase MAXIMUM_PASSWORD_SIZE value for more
            guard let bruteWorkItem = bruteWorkItem, !bruteWorkItem.isCancelled else {
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
