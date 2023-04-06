//
//  secp256k1_prvkey+Verify.swift
//  mew-wallet-ios-secp256k1
//
//  Created by Mikhail Nikanorov
//  Copyright © 2023 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import mew_wallet_ios_secp256k1_lib

/// This extension adds functionality to the `secp256k1_prvkey` struct, allowing it to be easily verify private key
extension secp256k1_prvkey {
  /// This function checks if the `secp256k1_prvkey` instance is valid by verifying it using the `secp256k1_ec_seckey_verify` function.
  /// - Throws: `secp256k1.Error.secp256k1_invalidPrivateKey` if the private key is not valid.
  public func verify() throws {
    // Create a secp256k1 context for verifying the private key.
    let context = try secp256k1_context()
    
    // Attempt to verify the private key using the secp256k1_ec_seckey_verify function.
    let result = secp256k1_ec_seckey_verify(context.rawValue, self.rawValue.bytes)
    
    // If the result is not 1, the private key is invalid, so throw an error.
    guard result == 1 else { throw secp256k1.Error.secp256k1_invalidPrivateKey }
  }
}
