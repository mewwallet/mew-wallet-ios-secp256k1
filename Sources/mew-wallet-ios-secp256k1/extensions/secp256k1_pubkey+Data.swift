//
//  secp256k1_pubkey+Data.swift
//  mew-wallet-ios-secp256k1
//
//  Created by Mikhail Nikanorov
//  Copyright © 2023 MyEtherWallet Inc. All rights reserved.
//


import Foundation
import mew_wallet_ios_secp256k1_lib

/// This extension adds functionality to the `secp256k1_pubkey` struct, allowing it to be easily converted to a Swift `Data` object.
extension secp256k1_pubkey {
  /// This computed property returns the raw binary data of the `secp256k1_pubkey` as a Swift `Data` object.
  public var rawValue: Data {
    var data = self.data
    return Data(withUnsafeBytes(of: &data, { Array($0) }))
  }
  
  /// This initializer creates a new `secp256k1_pubkey` instance by parsing the provided `Data` object.
  /// The data must be either 33 or 65 bytes long to represent a compressed or uncompressed public key, respectively.
  /// - Parameter data: The `Data` object containing the serialized public key.
  /// - Throws: `secp256k1.Error.secp256k1_invalidPublicKey` if the data length is incorrect or if the public key is not valid.
  public init(data: Data) throws {
    // Ensure the data length is either 33 bytes (compressed) or 65 bytes (uncompressed).
    guard data.count == 33 || data.count == 65 else { throw secp256k1.Error.secp256k1_invalidPublicKey }
    
    // Create a secp256k1 context for parsing the public key.
    let context = try secp256k1_context()
    
    // Create a mutable secp256k1_pubkey instance.
    var key = secp256k1_pubkey()
    
    // Attempt to parse the provided data into a secp256k1_pubkey instance.
    let result = secp256k1_ec_pubkey_parse(context.rawValue, &key, data.bytes, data.count)
    
    // If the result is not 1, the public key is invalid, so throw an error.
    guard result == 1 else { throw secp256k1.Error.secp256k1_invalidPublicKey }
    
    // Assign the parsed secp256k1_pubkey instance to `self`.
    self = key
  }
}
