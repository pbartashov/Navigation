//
//  OperationBruteForceService.swift
//  Navigation
//
//  Created by Павел Барташов on 03.07.2022.
//

import Foundation

final class OperationBruteForceService: BruteForceServiceProtocol {

    //MARK: - Properties

    var bruteForcer: BruteForcerProtocol

    var completion: ((BruteForceState) -> Void)?

    var progress: ((Int, String) -> Void)?

    lazy var bruteForceQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "BruteForce queue"
        queue.qualityOfService = .userInitiated
//        queue.maxConcurrentOperationCount = 1

        return queue
    }()

    //MARK: - LifeCicle

    init(bruteForcer: BruteForcerProtocol) {
        self.bruteForcer = bruteForcer
    }

    //MARK: - Metods

    func start(passwordToUnlock: String) {
        cancel()

        let bruteForceOperation = BruteForceOperation(passwordToUnlock: passwordToUnlock,
                                                      bruteForcer: bruteForcer)
        bruteForceOperation.progress = progress

        bruteForceOperation.completionBlock = { [weak self] in
            guard let self = self else { return }

            if bruteForceOperation.isCancelled {
                self.completion?(.cancel)
                return
            }

            if bruteForceOperation.result.isEmpty {
                self.completion?(.fail)
            } else {
                self.completion?(.success(password: bruteForceOperation.result))
            }
        }

        bruteForceQueue.addOperation(bruteForceOperation)
    }

    func cancel() {
        bruteForceQueue.cancelAllOperations()
    }
}
