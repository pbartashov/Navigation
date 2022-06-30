//
//  BruteForce.swift
//  Navigation
//
//  Created by Павел Барташов on 29.06.2022.
//

import Foundation

//https://github.com/netology-code/iosint-homeworks/blob/iosint-3/6/Brut%20Force.zip
final class BruteForce{

    private func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character))!
    }

    private func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index])
        : Character("")
    }

    private func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var str: String = string

        if str.count <= 0 {
            str.append(characterAt(index: 0, array))
        }
        else {
            str.replace(at: str.count - 1,
                        with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))

            if indexOf(character: str.last!, array) == 0 {
                str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
            }
        }

        return str
    }

    func bruteForce(passwordToUnlock: String) {
        let ALLOWED_CHARACTERS: [String] = String().printable.map { String($0) }

        var password: String = ""

        let startTime = Date()
        print("started at: \(startTime)")

        // Will strangely ends at 0000 instead of ~~~
        while password != passwordToUnlock { // Increase MAXIMUM_PASSWORD_SIZE value for more
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
            // Your stuff here
                        print(password)
            // Your stuff here
        }

        let endTime = Date()
        print("finished at: \(endTime)")

        let duration = String(format: "%.2f", endTime.timeIntervalSince(startTime))
        print("duration: \(duration)")
        print("password: \(password)")
    }
}



