//
//  String+.swift
//  NavigationUITests
//
//  Created by Павел Барташов on 30.10.2022.
//

import Foundation

extension String {
    var localized: String {
        let testBundle = Bundle(for: NavigationUITests.self)
        let currentLocale = Locale.current
        if let code = currentLocale.language.languageCode?.identifier,
           let testBundlePath = testBundle.path(forResource: code, ofType: "lproj")
            ?? testBundle.path(forResource: code, ofType: "lproj"), let localizedBundle = Bundle(path: testBundlePath) {

            return NSLocalizedString(self, bundle: localizedBundle, comment: "")
        }
        return ""
    }
}
