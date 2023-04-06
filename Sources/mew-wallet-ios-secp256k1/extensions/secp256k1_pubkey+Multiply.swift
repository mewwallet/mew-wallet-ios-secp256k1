//
//  secp256k1_pubkey+Multiply.swift
//  mew-wallet-ios-secp256k1
//
//  Created by Mikhail Nikanorov
//  Copyright © 2023 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import mew_wallet_ios_secp256k1_lib

/// This extension defines the multiplication operator for the `secp256k1_pubkey` and `secp256k1_prvkey` types.
extension secp256k1_pubkey {
  /// Multiplies the public key by the private key scalar and returns a new public key.
  /// - Parameters:
  ///   - left: The public key to be multiplied.
  ///   - right: The private key scalar to multiply the public key by.
  /// - Throws: An error if the multiplication operation fails.
  /// - Returns: A new `secp256k1_pubkey` instance that is the result of the multiplication operation.
  public static func * (left: secp256k1_pubkey, right: secp256k1_prvkey) throws -> secp256k1_pubkey {
    // Create a new secp256k1 context for the multiplication operation.
    let context = try secp256k1_context()
    
    // Make a mutable copy of the input public key.
    var left = left
    
    // Perform the point multiplication of the public key by the private key scalar using the secp256k1 context.
    let result = secp256k1_ec_pubkey_tweak_mul(context.rawValue, &left, right.rawValue.bytes)
    
    // Check if the multiplication operation was successful (result should equal 1).
    guard result == 1 else { throw secp256k1.Error.secp256k1_tweakMulFailure }
    
    // Return the new public key that is the result of the multiplication operation.
    return left
  }
}
