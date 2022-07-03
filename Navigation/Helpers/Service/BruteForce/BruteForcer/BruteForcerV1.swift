//
//  BruteForcerV1.swift
//  Navigation
//
//  Created by Павел Барташов on 03.07.2022.
//

//https://github.com/netology-code/iosint-homeworks/blob/iosint-3/6/Brut%20Force.zip
struct BruteForcerV1: BruteForcerProtocol {

    //MARK: - Properties

    private let allowedCharacters: [String]

    //MARK: - LifeCicle

    init(allowedCharacters: String) {
        self.allowedCharacters = allowedCharacters.map { String($0) }
    }
    
    //MARK: - Metods

    private func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character))!
    }

    private func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index])
        : Character("")
    }

    func generateBruteForce(_ string: String) -> String {
        var str: String = string

        if str.count <= 0 {
            str.append(characterAt(index: 0, allowedCharacters))
        }
        else {
            str.replace(at: str.count - 1,
                        with: characterAt(index: (indexOf(character: str.last!, allowedCharacters) + 1) % allowedCharacters.count, allowedCharacters))

            if indexOf(character: str.last!, allowedCharacters) == 0 {
                str = String(generateBruteForce(String(str.dropLast()))) + String(str.last!)
            }
        }

        return str
    }
}
