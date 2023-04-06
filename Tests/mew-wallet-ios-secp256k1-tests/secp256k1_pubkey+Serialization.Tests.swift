//
//  secp256k1_pubkey+Serialization.Tests.swift
//  mew-wallet-ios-secp256k1
//
//  Created by Mikhail Nikanorov
//  Copyright © 2023 MyEtherWallet Inc. All rights reserved.
//

import XCTest
@testable import mew_wallet_ios_secp256k1
import mew_wallet_ios_secp256k1_lib

final class secp256k1_pubkey_Serialization_Tests: XCTestCase {
  func testPubkeySerialization() throws {
    let context = try secp256k1_context()
    
    let privateKey = try Array<UInt8>.secRandom(length: 32)
    
    var publicKey = secp256k1_pubkey()
    XCTAssertEqual(secp256k1_ec_pubkey_create(context.rawValue, &publicKey, privateKey), 1)
    
    let uncompressedSerializedPubkey = try publicKey.serialized
    
    let compressedSerializedPubkey = try publicKey.serializedCompressed
    
    XCTAssertEqual(uncompressedSerializedPubkey.count, 65, "Uncompressed serialized public key should have a length of 65 bytes.")
    XCTAssertEqual(compressedSerializedPubkey.count, 33, "Compressed serialized public key should have a length of 33 bytes.")
  }
}
