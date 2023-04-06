//
//  secp256k1_ecdsa_recoverable_signature+PublicKey.swift
//  mew-wallet-ios-secp256k1
//
//  Created by Mikhail Nikanorov
//  Copyright © 2023 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import mew_wallet_ios_secp256k1_lib

extension secp256k1_ecdsa_recoverable_signature {
  /// This function recovers the public key associated with the recoverable signature and the provided hash.
  /// - Parameter hash: A Data object containing the 32-byte hash.
  /// - Returns: The recovered `secp256k1_pubkey`.
  /// - Throws: An error if the hash size is invalid or the recovery fails.
  public func publicKey(with hash: Data) throws -> secp256k1_pubkey {
    // Ensure the hash has the correct length (32 bytes).
    guard hash.count == 32 else { throw secp256k1.Error.secp256k1_invalidHashSize }
    
    // Initialize an empty secp256k1_pubkey.
    var pubKey = secp256k1_pubkey()
    
    // Create a secp256k1 context for recovery.
    let context = try secp256k1_context()
    
    // Make a mutable copy of `self`.
    var `self` = self
    
    // Recover the public key using the secp256k1_ecdsa_recover function.
    let result = secp256k1_ecdsa_recover(context.rawValue, &pubKey, &self, hash.bytes)
    
    // Ensure the recovery was successful (result should be equal 0).
    guard result == 1 else { throw secp256k1.Error.secp256k1_recoverFailure }
    
    // Return the recovered public key.
    return pubKey
  }
}
