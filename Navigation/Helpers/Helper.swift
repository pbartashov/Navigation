//
//  Helper.swift
//  Navigation
//
//  Created by Павел Барташов on 13.03.2022.
//

import UIKit

//https://stackoverflow.com/questions/49614659/generate-list-of-unique-random-numbers-in-swift-from-range
func getUniqueRandomNumbers(min: Int, max: Int, count: Int) -> [Int] {
    var set = Set<Int>()
    while set.count < count {
        set.insert(Int.random(in: min...max))
    }
    
    return Array(set)
}
