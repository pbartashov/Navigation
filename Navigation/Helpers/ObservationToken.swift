//
//  ObservationToken.swift
//  Navigation
//
//  Created by Павел Барташов on 21.06.2022.
//

//https://www.swiftbysundell.com/articles/observers-in-swift-part-2/
final class ObservationToken {
    private let cancellationClosure: () -> Void

    init(cancellationClosure: @escaping () -> Void) {
        self.cancellationClosure = cancellationClosure
    }

    func cancel() {
        cancellationClosure()
    }
}
