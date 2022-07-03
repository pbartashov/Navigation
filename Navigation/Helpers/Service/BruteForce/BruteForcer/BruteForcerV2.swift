//
//  BruteForcerV2.swift
//  Navigation
//
//  Created by Павел Барташов on 03.07.2022.
//

struct BruteForcerV2: BruteForcerProtocol {

    //MARK: - Properties

    private let allowedCharacters: [Character]
    private var indexes: [Int] = [0]

    //MARK: - LifeCicle

    init(allowedCharacters: String) {
        self.allowedCharacters = Array(allowedCharacters)
    }

    //MARK: - Metods

    mutating func generateBruteForce(_ password: String) -> String {
        let result = indexes.reduce(into: "") { partialResult, i in
            partialResult.append(allowedCharacters[i])
        }

        var i = 0
        indexes[i] += 1

        while indexes[i] >= allowedCharacters.count {
            indexes[i] = 0

            i += 1

            if i >= indexes.count {
                indexes.append(0)
                break
            }

            indexes[i] += 1
        }

        return result
    }

    mutating func reset() {
        indexes = [0]
    }
}
