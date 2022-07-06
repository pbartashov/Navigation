//
//  Print.swift
//  Navigation
//
//  Created by Павел Барташов on 05.07.2022.
//

import Foundation

struct Print {
    static func bruteForcePasswordDuration(from startTime: Date, till endTime:Date = Date(), for password: String) {
        let duration = String(format: "%.2f", endTime.timeIntervalSince(startTime))
        print("duration: \(duration)")
        print("password: \(password)")
    }

    static func description(of bruteForceOperationfor: BruteForceOperation,
                            for action: String,
                            at date: Date = Date()) {

        if bruteForceOperationfor.lengthLimit > 0 {
            var template = ""
            for _ in 0..<bruteForceOperationfor.lengthLimit {
                template.append("?")
            }

            print("\(bruteForceOperationfor.passwordToUnlock) with template \(template)\(bruteForceOperationfor.suffix) \(action) at: \(date)")
        } else {
            print("\(bruteForceOperationfor.passwordToUnlock) \(action) at: \(date)")
        }
    }
}
