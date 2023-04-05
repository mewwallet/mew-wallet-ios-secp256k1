//
//  secp256k1_pubkey+Data.Tests.swift
//  mew-wallet-ios-secp256k1
//
//  Created by Mikhail Nikanorov
//  Copyright © 2023 MyEtherWallet Inc. All rights reserved.
//

import XCTest
@testable import mew_wallet_ios_secp256k1
import mew_wallet_ios_secp256k1_lib

final class secp256k1_pubkey_Data: XCTestCase {
  func testPubkeyToDataConversion() throws {
    let context = try secp256k1_context()
    
    let privateKey = try secp256k1_prvkey(rawValue: Data([UInt8].secRandom(length: 32)))!
    
    var publicKey = secp256k1_pubkey()
    let result = secp256k1_ec_pubkey_create(context.rawValue, &publicKey, privateKey.rawValue.bytes)
    
    XCTAssertEqual(result, 1, "Public key creation should be successful.")
    XCTAssertEqual(try privateKey.pubkey.rawValue, publicKey.rawValue)
  }
  
  func testValidPublicKey() throws {
    // Generate a valid private key.
    let privateKeyData = Data([0x3b, 0x7e, 0x1c, 0x8d, 0x18, 0xa2, 0x8b, 0x15, 0x3b, 0x87,
                               0xf6, 0xbb, 0xd0, 0xe1, 0x62, 0xc8, 0xa6, 0xc1, 0xd2, 0xc4,
                               0xf6, 0xf4, 0xe6, 0xa8, 0xd6, 0xe8, 0xf6, 0xc0, 0xe6, 0xe6,
                               0xe6, 0xe6])
    let privateKey = try secp256k1_prvkey(data: privateKeyData)
    
    // Derive the public key from the private key.
    XCTAssertNoThrow(try privateKey.pubkey, "Deriving the public key from a valid private key should not throw an error.")
    let publicKey = try privateKey.pubkey
    
    // Serialize the derived public key and create a new secp256k1_pubkey instance using the serialized data.
    XCTAssertNoThrow(try secp256k1_pubkey(data: publicKey.serializedCompressed), "Creating a public key from valid serialized data should not throw an error.")
    let publicKeyFromData = try secp256k1_pubkey(data: publicKey.serializedCompressed)
    
    // Compare the original public key and the one created from the serialized data.
    XCTAssertEqual(publicKey.rawValue, publicKeyFromData.rawValue, "Both public keys should have the same raw value.")
  }
  
  
  func testInvalidPublicKey() {
    let invalidPublicKeyData = Data([UInt8](repeating: 0, count: 33))
    XCTAssertThrowsError(try secp256k1_pubkey(data: invalidPublicKeyData), "An invalid public key should throw an error.") { error in
      XCTAssertEqual(error as? secp256k1.Error, secp256k1.Error.secp256k1_invalidPublicKey)
    }
  }
}
