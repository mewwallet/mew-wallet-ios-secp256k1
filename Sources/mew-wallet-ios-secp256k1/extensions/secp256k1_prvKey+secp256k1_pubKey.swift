//
//  secp256k1_prvkey+secp256k1_pubKey.swift
//  mew-wallet-ios-secp256k1
//
//  Created by Mikhail Nikanorov
//  Copyright © 2023 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import mew_wallet_ios_secp256k1_lib

/// This extension adds a convenience property to the `secp256k1_prvkey` struct,
/// allowing the derivation of the associated secp256k1 public key.
extension secp256k1_prvkey {
  /// This computed property returns the associated `secp256k1_pubkey` for the current private key.
  /// It throws an error if the public key cannot be derived from the private key.
  public var pubkey: secp256k1_pubkey {
    get throws {
      // Create a new secp256k1 context instance, initialized with cryptographically secure random data.
      let context = try secp256k1_context()
      
      // Initialize an empty secp256k1_pubkey.
      var key = secp256k1_pubkey()
      
      // Derive the public key from the private key using the secp256k1_ec_pubkey_create function.
      let result = secp256k1_ec_pubkey_create(context.rawValue, &key, self.rawValue.bytes)
      
      // Ensure the public key derivation was successful (result should equal 1).
      // If not, throw an error indicating the private key is invalid.
      guard result == 1 else { throw secp256k1.Error.secp256k1_invalidPrivateKey }
      
      // Return the derived secp256k1_pubkey.
      return key
    }
  }
}
