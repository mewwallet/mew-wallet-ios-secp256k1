//
//  secp256k1_context.swift
//  mew-wallet-ios-secp256k1
//
//  Created by Mikhail Nikanorov
//  Copyright © 2023 MyEtherWallet Inc. All rights reserved.
//

import Foundation
import mew_wallet_ios_secp256k1_lib

/// This struct wraps the `secp256k1_context` (`OpaquePointer`) from the secp256k1 library in a Swift-friendly way by conforming to the `RawRepresentable` protocol.
public final class secp256k1_context: RawRepresentable {
  public typealias RawValue = OpaquePointer

  public var rawValue: OpaquePointer
  
  public init?(rawValue: OpaquePointer) {
    self.rawValue = rawValue
  }
  
  /// This function creates a new `secp256k1_context` instance with no predefined capabilities,
  /// but initialized with cryptographically secure random data as a seed.
  /// - Throws: An error if generating cryptographically secure random data fails.
  /// - Returns: A `secp256k1_context` instance initialized with a secure random seed.
  public init() throws {
    // Generate a cryptographically secure random seed with a length of 32 bytes.
    let seed: [UInt8] = try .secRandom(length: 32)
    
    // Create a new secp256k1_context instance with no predefined capabilities (SECP256K1_CONTEXT_NONE).
    let context = secp256k1_context_create(UInt32(bitPattern: SECP256K1_CONTEXT_NONE))
    assert(context != nil)
    
    // Randomize the context using the generated seed.
    let result = secp256k1_context_randomize(context!, seed)
    
    // Ensure the randomization was successful (result should equal 1).
    guard result == 1 else {
      throw secp256k1.Error.secp256k1_randomizeError
    }
    
    // Return the randomized secp256k1_context instance.
    self.rawValue = context!
  }
  
  deinit {
    // Destroy the underlying secp256k1_context, freeing the memory it occupies.
    secp256k1_context_destroy(rawValue)
  }
}
