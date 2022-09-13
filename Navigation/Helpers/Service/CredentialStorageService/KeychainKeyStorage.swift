//
//  KeychainKeyStorage.swift
//  Navigation
//
//  Created by Павел Барташов on 27.08.2022.
//

import Foundation

struct KeychainKeyStorage {
    //https://www.mongodb.com/docs/realm/sdk/swift/realm-files/encrypt-a-realm/
    // Retrieve the existing encryption key for the app if it exists or create a new one
    static func getKey() -> Data {
        // Identifier for our keychain entry - should be unique for your application
        let keychainIdentifier: [UInt8] = [99, 111, 109, 46, 112, 66, 46, 78, 97, 118, 105, 103, 97, 116, 105, 111, 110, 46, 67, 114, 101, 100, 101, 110, 116, 105, 97, 108, 83, 116, 111, 114, 97, 103, 101, 69, 110, 99, 114, 121, 112, 116, 105, 111, 110, 75, 101, 121]

        let keychainIdentifierData = Data(keychainIdentifier)
        // First check in the keychain for an existing key
        var query: [NSString: AnyObject] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecReturnData: true as AnyObject
        ]
        // To avoid Swift optimization bug, should use withUnsafeMutablePointer() function to retrieve the keychain item
        // See also: http://stackoverflow.com/questions/24145838/querying-ios-keychain-using-swift/27721328#27721328
        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        if status == errSecSuccess {
            // swiftlint:disable:next force_cast
            return dataTypeRef as! Data
        }
        // No pre-existing key from this application, so generate a new one
        // Generate a random encryption key
        var key = Data(count: 64)
        key.withUnsafeMutableBytes({ (pointer: UnsafeMutableRawBufferPointer) in
            let result = SecRandomCopyBytes(kSecRandomDefault, 64, pointer.baseAddress!)
            assert(result == 0, "Failed to get random bytes")
        })
        // Store the key in the keychain
        query = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecValueData: key as AnyObject
        ]
        status = SecItemAdd(query as CFDictionary, nil)
        assert(status == errSecSuccess, "Failed to insert the new key in the keychain")
        return key
    }
}
