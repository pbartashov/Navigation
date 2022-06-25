//
//  FeedViewControllerModel.swift
//  Navigation
//
//  Created by Павел Барташов on 21.06.2022.
//

import Foundation

protocol FeedViewControllerModelProtocol {
    func check(word: String)

    @discardableResult
    func addCheckPassedObserver<T: AnyObject>(
        _ observer: T,
        closure: @escaping (T, FeedViewControllerModelProtocol) -> Void
    ) -> ObservationToken

    @discardableResult
    func addCheckFailedObserver<T: AnyObject>(
        _ observer: T,
        closure: @escaping (T, FeedViewControllerModelProtocol) -> Void
    ) -> ObservationToken
}

final class FeedViewControllerModel: FeedViewControllerModelProtocol {

    //MARK: - Properties

    let password = "123"

    private var observations = (
        checkPassed: [UUID : (FeedViewControllerModelProtocol) -> Void](),
        checkFailed: [UUID : (FeedViewControllerModelProtocol) -> Void]()
    )

    //MARK: - Metods

    func addCheckPassedObserver<T: AnyObject>(
        _ observer: T,
        closure: @escaping (T, FeedViewControllerModelProtocol) -> Void
    ) -> ObservationToken {
        let id = UUID()

        observations.checkPassed[id] = { [weak self, weak observer] model in
            // If the observer has been deallocated, we can
            // automatically remove the observation closure.
            guard let observer = observer else {
                self?.observations.checkPassed.removeValue(forKey: id)
                return
            }

            closure(observer, model)
        }

        return ObservationToken { [weak self] in
            self?.observations.checkPassed.removeValue(forKey: id)
        }
    }

    func addCheckFailedObserver<T: AnyObject>(
        _ observer: T,
        closure: @escaping (T, FeedViewControllerModelProtocol) -> Void
    ) -> ObservationToken {
        let id = UUID()

        observations.checkFailed[id] = { [weak self, weak observer] model in
            // If the observer has been deallocated, we can
            // automatically remove the observation closure.
            guard let observer = observer else {
                self?.observations.checkFailed.removeValue(forKey: id)
                return
            }

            closure(observer, model)
        }

        return ObservationToken { [weak self] in
            self?.observations.checkFailed.removeValue(forKey: id)
        }
    }

    func check(word: String) {
        (word.hash == password.hash
         ? observations.checkPassed
         : observations.checkFailed
        )
        .values.forEach { closure in
            closure(self)
        }
    }
}
