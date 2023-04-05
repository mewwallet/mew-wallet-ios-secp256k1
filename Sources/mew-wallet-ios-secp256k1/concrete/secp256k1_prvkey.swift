//
//  secp256k1_prvkey.swift
//  mew-wallet-ios-secp256k1
//
//  Created by Mikhail Nikanorov
//  Copyright © 2023 MyEtherWallet Inc. All rights reserved.
//


import Foundation
import mew_wallet_ios_secp256k1_lib

/// The `secp256k1_prvkey` struct represents a secp256k1 private key in a Swift-friendly way, conforming to the `RawRepresentable` protocol.
public struct secp256k1_prvkey: RawRepresentable {
  public typealias RawValue = Data

  public var rawValue: Data
  
  /// This failable initializer creates a `secp256k1_prvkey` instance from a `Data` object, returning `nil` if the private key is not of valid length.
  /// - Parameter rawValue: A `Data` object representing the private key.
  /// - Returns: A `secp256k1_prvkey` instance if the private key length is 32 bytes, or `nil` otherwise.
  public init?(rawValue: Data) {
    guard rawValue.count == 32 else { return nil }
    self.rawValue = rawValue
  }
  
  /// This initializer creates a `secp256k1_prvkey` instance from a `Data` object, ensuring the private key is of valid length.
  /// - Parameter data: A `Data` object representing the private key.
  /// - Throws: A `secp256k1.Error.secp256k1_invalidPrivateKey` error if the private key length is not 32 bytes.
  public init(data: Data) throws {
    guard data.count == 32 else { throw secp256k1.Error.secp256k1_invalidPrivateKey }
    self.rawValue = data
  }
}
