//
//  Array+UInt8+SecRandomCopyBytes.swift
//  mew-wallet-ios-secp256k1
//
//  Created by Mikhail Nikanorov
//  Copyright © 2023 MyEtherWallet Inc. All rights reserved.
//


import Foundation

/// This extension adds functionality to arrays of UInt8 elements, allowing the generation of cryptographically secure random data.
extension Array where Element == UInt8 {
  static func secRandom(length: Int) throws -> [Element] {
    // Check if required length in a safe range
    guard length > 0 else { throw secp256k1.Error.secRandomCopyBytesBadLength }
    
    // Initialize an empty array of UInt8 elements with a reserved capacity equal to the desired length.
    var bytes: [UInt8] = Array(repeating: 0x00, count: length)
    
    // Use the Security framework's SecRandomCopyBytes function to generate cryptographically secure random data and fill the array.
    let result = SecRandomCopyBytes(kSecRandomDefault, length, &bytes)
    
    // Check if the random data generation was successful (errSecSuccess). If not, throw an error with the error code.
    guard result == errSecSuccess else {
      throw secp256k1.Error.secRandomCopyBytesError(code: result)
    }
    
    // Return the array filled with cryptographically secure random data.
    return bytes
  }
}
