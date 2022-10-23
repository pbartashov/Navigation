//
//  String+Extension.swift
//  Navigation
//
//  Created by Павел Барташов on 29.06.2022.
//

import Foundation

//https://github.com/netology-code/iosint-homeworks/blob/iosint-3/6/Brut%20Force.zip
extension String {
    var digits:         String { "0123456789" }
    var lowercase:      String { "abcdefghijklmnopqrstuvwxyz" }
    var uppercase:      String { "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation:    String { "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters:        String { lowercase + uppercase }
    var digitsLetters:  String { digits + letters }
    var printable:      String { digitsLetters + punctuation }

    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }
}

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
