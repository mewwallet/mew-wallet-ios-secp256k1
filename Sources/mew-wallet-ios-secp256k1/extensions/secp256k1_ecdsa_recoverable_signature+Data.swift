//
//  secp256k1_ecdsa_recoverable_signature+Data.swift
//  mew-wallet-ios-secp256k1
//
//  Created by Mikhail Nikanorov
//  Copyright © 2023 MyEtherWallet Inc. All rights reserved.
//


import Foundation
import mew_wallet_ios_secp256k1_lib

/// This extension adds functionality to the `secp256k1_ecdsa_recoverable_signature` struct, allowing it to be easily converted to a Swift `Data` object.
extension secp256k1_ecdsa_recoverable_signature {
  /// This computed property returns the raw binary data of the `secp256k1_ecdsa_recoverable_signature` as a Swift `Data` object.
  public var rawValue: Data {
    var data = self.data
    return Data(withUnsafeBytes(of: &data, { Array($0) }))
  }
  
  /// This computed property returns a serialized representation of the recoverable signature as a Swift `Data` object.
  /// The serialized data includes a 64-byte compact representation of the signature and a 1-byte recovery identifier.
  /// - Throws: An error if the signature serialization fails.
  public var serialized: Data {
    get throws {
      // Initialize an array of 65 bytes with zeros.
      var serialized = [UInt8](repeating: 0x00, count: 65)
      
      // Declare a variable to store the recovery identifier.
      var v: Int32 = 0
      
      // Create a secp256k1 context for serialization.
      let context = try secp256k1_context()

      var `self` = self
      // Serialize the recoverable signature into the `serialized` array.
      let result = secp256k1_ecdsa_recoverable_signature_serialize_compact(context.rawValue, &serialized, &v, &self)
      
      // Check if the serialization was successful (result should be equal 1).
      guard result == 1 else { throw secp256k1.Error.secp256k1_serializeFailure }
      
      // Check if the recovery identifier is valid (either 0 or 1).
      guard v == 0 || v == 1 else { throw secp256k1.Error.secp256k1_serializeFailure }
      
      // Set the recovery identifier as the last byte of the serialized array.
      serialized[64] = UInt8(clamping: v)
      
      // Return the serialized recoverable signature as a Swift `Data` object.
      return Data(serialized)
    }
  }
  
  /// This initializer creates a `secp256k1_ecdsa_recoverable_signature` instance from a serialized representation.
  /// The input data should include a 64-byte compact representation of the signature and a 1-byte recovery identifier.
  /// - Parameter data: A `Data` object containing the serialized recoverable signature.
  /// - Throws: An error if the input data has an incorrect size or the signature parsing fails.
  public init(data: Data) throws {
    // Check if the input data has the correct size (65 bytes).
    guard data.count == 65 else { throw secp256k1.Error.secp256k1_invalidSignatureSize }
    
    // Create a secp256k1 context for parsing.
    let context = try secp256k1_context()
    
    // Initialize an empty secp256k1_ecdsa_recoverable_signature instance.
    var signature = secp256k1_ecdsa_recoverable_signature()
    
    // Extract the serialized signature and recovery identifier from the input data.
    var serialized = data[0 ..< 64].bytes
    let v = Int32(data[64])
    
    // Parse the serialized recoverable signature.
    let result = secp256k1_ecdsa_recoverable_signature_parse_compact(context.rawValue, &signature, &serialized, v)
    
    // Check if the signature parsing was successful (result should be equal 1).
    guard result == 1 else { throw secp256k1.Error.secp256k1_signatureParseFailure }
    
    // Return the parsed recoverable signature.
    self = signature
  }
}
