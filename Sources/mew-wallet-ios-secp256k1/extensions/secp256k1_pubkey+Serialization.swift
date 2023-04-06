//
//  secp256k1_pubkey+Serialization.swift
//  mew-wallet-ios-secp256k1
//
//  Created by Mikhail Nikanorov
//  Copyright © 2023 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import mew_wallet_ios_secp256k1_lib

/// This extension adds serialization functionality to the `secp256k1_pubkey` struct,
/// allowing the conversion of the public key into a Data object in both uncompressed and compressed formats.
extension secp256k1_pubkey {
  /// This computed property returns the uncompressed serialized representation of the `secp256k1_pubkey` as a Swift `Data` object.
  public var serialized: Data {
    get throws {
      return try serialize(flag: SECP256K1_EC_UNCOMPRESSED)
    }
  }
  
  /// This computed property returns the compressed serialized representation of the `secp256k1_pubkey` as a Swift `Data` object.
  public var serializedCompressed: Data {
    get throws {
      return try serialize(flag: SECP256K1_EC_COMPRESSED)
    }
  }
  
  // MARK: - Private
  
  /// This private function serializes the `secp256k1_pubkey` using the provided flag.
  /// - NOTE: secp256k1_pubkey must be valid, but there's no good way to check it without serialization
  /// - Parameter flag: An Int32 representing the desired serialization format (uncompressed or compressed).
  /// - Returns: The serialized `Data` representation of the public key.
  /// - Throws: An error if the serialization fails.
  private func serialize(flag: Int32) throws -> Data {
    // Initialize the size of the serialized public key.
    var keySizeT: size_t = 65
    
    // Allocate memory for the serialized public key
    let serializedKey = UnsafeMutablePointer<UInt8>.allocate(capacity: keySizeT)
    defer {
      serializedKey.deallocate()
    }
    
    // Create a secp256k1 context for serialization.
    let context = try secp256k1_context()
    
    // Make a mutable copy of `self`.
    var `self` = self
    
    // Serialize the public key using the secp256k1_ec_pubkey_serialize function.
    let result = secp256k1_ec_pubkey_serialize(context.rawValue, serializedKey, &keySizeT, &self, UInt32(flag))
    
    // Ensure the serialization was successful (result should be 1).
    guard result == 1 else {
      throw secp256k1.Error.secp256k1_serializeFailure
    }
    
    // Return the serialized public key as a Data object.
    return Data(bytes: serializedKey, count: keySizeT)
  }
}
