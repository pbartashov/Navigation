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

    var operationCount: Int = 3
    var lengthLimit: Int = 4

    var completion: ((BruteForceState) -> Void)?

    var progress: ((Int, String) -> Void)?

    lazy var bruteForceQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "BruteForce queue"
        queue.qualityOfService = .utility
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
    private var isCancelled = false

    private var startTime: Date?

    //MARK: - LifeCicle

    init(bruteForcer: BruteForcerProtocol) {
        self.bruteForcer = bruteForcer
        self.currentSuffix = ""
        self.suffixBruteForcer = BruteForcerV2(allowedCharacters: bruteForcer.allowedCharacters)
    }

    //MARK: - Metods

    func start(passwordToUnlock: String) {
        cancel()
        suffixBruteForcer.reset()

        startTime = Date()
        isCancelled = false

        for _ in 0..<operationCount {
            scheduleOperation(passwordToUnlock)
        }
    }

    func cancel() {
        isCancelled = true

        schedulerQueue.isSuspended = true

        bruteForceQueue.cancelAllOperations()
        bruteForceQueue.waitUntilAllOperationsAreFinished()

        schedulerQueue.isSuspended = false
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
                if self.isCancelled || bruteForceOperation.isCancelled {
                    self.completion?(.cancel)
                    return
                }

                if bruteForceOperation.result.isEmpty {
                    self.scheduleOperation(passwordToUnlock)
                } else {
                    self.cancel()

                    Print.bruteForcePasswordDuration(from: self.startTime ?? Date(), for: bruteForceOperation.result)

                    self.completion?(.success(password: bruteForceOperation.result))
                }
            }
        }

        bruteForceQueue.addOperation(bruteForceOperation)
    }
}
