//
//  Data+Sign.swift
//  mew-wallet-ios-secp256k1
//
//  Created by Mikhail Nikanorov
//  Copyright © 2023 MyEtherWallet Inc. All rights reserved.
//


import Foundation
import mew_wallet_ios_secp256k1_lib

extension Data {
  /// Signs the data using the provided private key, generating a secp256k1 ECDSA recoverable signature.
  /// - Parameters:
  ///   - key: A `secp256k1_prvkey` instance representing the private key used to sign the data.
  ///   - extraEntropy: An optional flag to indicate whether extra entropy should be added to the nonce function. Default value is `false`.
  /// - Throws: An error if the provided data has an incorrect size, the signature generation fails, or generating cryptographically secure random data fails (when `extraEntropy` is `true`).
  /// - Returns: A `secp256k1_ecdsa_recoverable_signature` instance representing the generated signature.
  public func sign(key: secp256k1_prvkey, extraEntropy: Bool = false) throws -> secp256k1_ecdsa_recoverable_signature {
    // Check if the data has the correct size (32 bytes).
    guard self.count == 32 else { throw secp256k1.Error.secp256k1_invalidHashSize }
    
    // Create a secp256k1 context for signing.
    let context = try secp256k1_context()
    
    // Initialize an empty secp256k1_ecdsa_recoverable_signature instance.
    var signature = secp256k1_ecdsa_recoverable_signature()
    
    // Declare the result variable for the signing operation.
    let result: Int32
    
    // Perform the signing operation with or without extra entropy.
    if extraEntropy {
      let entropy: [UInt8] = try .secRandom(length: 32)
      result = secp256k1_ecdsa_sign_recoverable(context.rawValue, &signature, self.bytes, key.rawValue.bytes, secp256k1_nonce_function_rfc6979, entropy)
    } else {
      result = secp256k1_ecdsa_sign_recoverable(context.rawValue, &signature, self.bytes, key.rawValue.bytes, secp256k1_nonce_function_rfc6979, nil)
    }
    
    // Check if the signature generation was successful (result should be equal 1).
    guard result == 1 else { throw secp256k1.Error.secp256k1_signFailure }
    
    // Return the generated signature.
    return signature
  }
}
