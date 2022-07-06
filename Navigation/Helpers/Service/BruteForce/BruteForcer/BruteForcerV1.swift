//
//  BruteForcerV1.swift
//  Navigation
//
//  Created by Павел Барташов on 03.07.2022.
//

//https://github.com/netology-code/iosint-homeworks/blob/iosint-3/6/Brut%20Force.zip
struct BruteForcerV1: BruteForcerProtocol {

    //MARK: - Properties

    private let _allowedCharacters: [String]

    var allowedCharacters: String {
        _allowedCharacters.joined(separator: "")
    }

    //MARK: - LifeCicle

    init(allowedCharacters: String) {
        self._allowedCharacters = allowedCharacters.map { String($0) }
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
            str.append(characterAt(index: 0, _allowedCharacters))
        }
        else {
            str.replace(at: str.count - 1,
                        with: characterAt(index: (indexOf(character: str.last!, _allowedCharacters) + 1) % _allowedCharacters.count, _allowedCharacters))

            if indexOf(character: str.last!, _allowedCharacters) == 0 {
                str = String(generateBruteForce(String(str.dropLast()))) + String(str.last!)
            }
        }

        return str
    }
}
