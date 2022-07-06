//
//  Random.swift
//  Navigation
//
//  Created by Павел Барташов on 13.03.2022.
//

import UIKit


struct Random {
    //https://stackoverflow.com/questions/49614659/generate-list-of-unique-random-numbers-in-swift-from-range
    static func uniqueNumbers(min: Int, max: Int, count: Int) -> [Int] {
        var set = Set<Int>()
        while set.count < count {
            set.insert(Int.random(in: min...max))
        }

        return Array(set)
    }

    static func randomString(length: Int) -> String {
        var result = ""

        while result.count < length {
            if let character = result.digitsLetters.randomElement() {
                result.append(character)
            }
        }

        return result
    }

    //func getRandomStringV2(length: Int) -> String {
    //    let allowedSymbols = Array("".printable)
    //    let randomIndexes = getUniqueRandomNumbers(min: 0, max: allowedSymbols.count, count: length)
    //
    //    return randomIndexes
    //        .reduce(into: "", { result, index in
    //            result.append(allowedSymbols[index])
    //        })
    //}
}
