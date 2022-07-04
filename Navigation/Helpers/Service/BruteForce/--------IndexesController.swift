//
//  IndexesController.swift
//  Navigation
//
//  Created by Павел Барташов on 04.07.2022.
//

import Foundation

struct IndexesController {

    //MARK: - Properties

    let maxCount: Int
    private var indexes: [Int]

    //MARK: - Metods

    mutating func next() {
        var i = 0
        indexes[i] += 1

        while indexes[i] >= maxCount {
            indexes[i] = 0

            i += 1

            if i >= indexes.count {
                indexes.append(0)
                break
            }

            indexes[i] += 1
        }
    }
}
