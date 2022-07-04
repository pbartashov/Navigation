//
//  MultiOperationBruteForceService.swift
//  Navigation
//
//  Created by Павел Барташов on 04.07.2022.
//

import Foundation

final class MultiOperationBruteForceService: BruteForceServiceProtocol {

    //MARK: - Properties

    var bruteForcer: BruteForcerProtocol

    var operationCount: Int = 1
    var lengthLimit: Int = 4

    var completion: ((BruteForceState) -> Void)?

    var progress: ((Int, String) -> Void)?

    lazy var bruteForceQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "BruteForce queue"
        queue.qualityOfService = .userInitiated
//        queue.maxConcurrentOperationCount = 1

        return queue
    }()

    lazy var schedulerQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Scheduler queue"
        queue.qualityOfService = .userInitiated
        queue.maxConcurrentOperationCount = 1

        return queue
    }()

    private var currentSuffix: String
    private var suffixBruteForcer: BruteForcerV2

    //MARK: - LifeCicle

    init(bruteForcer: BruteForcerProtocol) {
        self.bruteForcer = bruteForcer
        self.currentSuffix = ""
        self.suffixBruteForcer = BruteForcerV2(allowedCharacters: bruteForcer.allowedCharacters)
    }

    //MARK: - Metods

    func start(passwordToUnlock: String) {
        cancel()

        for _ in 0..<operationCount {
            scheduleOperation(passwordToUnlock)
        }

    }

    func cancel() {
        bruteForceQueue.cancelAllOperations()
        schedulerQueue.cancelAllOperations()
    }

    private func scheduleOperation(_ passwordToUnlock: String) {
        let bruteForceOperation = BruteForceOperation(passwordToUnlock: passwordToUnlock,
                                                      bruteForcer: bruteForcer)
        bruteForceOperation.progress = progress
        bruteForceOperation.lengthLimit = lengthLimit
        bruteForceOperation.suffix = currentSuffix
        currentSuffix = suffixBruteForcer.generateBruteForce(currentSuffix)

        bruteForceOperation.completionBlock = { [weak self] in
            guard let self = self else { return }

            self.schedulerQueue.addOperation {
                if bruteForceOperation.isCancelled {
                    self.completion?(.cancel)
                    return
                }

                if bruteForceOperation.result.isEmpty {
//                    self.schedulerQueue.addOperation {
                        self.scheduleOperation(passwordToUnlock)
//                    }
                } else {

                    self.cancel()
                    self.completion?(.success(password: bruteForceOperation.result))
                }
            }
        }

        bruteForceQueue.addOperation(bruteForceOperation)


    }
}
