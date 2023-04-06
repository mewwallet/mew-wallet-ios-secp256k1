//
//  secp256k1_ecdsa_recoverable_signature+PublicKey.Tests.swift
//  mew-wallet-ios-secp256k1
//
//  Created by Mikhail Nikanorov
//  Copyright © 2023 MyEtherWallet Inc. All rights reserved.
//

import XCTest
@testable import mew_wallet_ios_secp256k1
import mew_wallet_ios_secp256k1_lib

final class secp256k1_ecdsa_recoverable_signature_PublicKey_Tests: XCTestCase {
  func testPublicKeyRecovery() throws {
    let context = try secp256k1_context()
    
    let privateKey = try [UInt8].secRandom(length: 32)
    
    var publicKey = secp256k1_pubkey()
    XCTAssertEqual(secp256k1_ec_pubkey_create(context.rawValue, &publicKey, privateKey), 1)
    
    let hash = try Data([UInt8].secRandom(length: 32))
    
    var signature = secp256k1_ecdsa_recoverable_signature()
    secp256k1_ecdsa_sign_recoverable(context.rawValue, &signature, hash.bytes, privateKey, nil, nil)
    
    let recoveredPublicKey = try signature.publicKey(with: hash)
    
    XCTAssertEqual(publicKey.rawValue, recoveredPublicKey.rawValue, "Original and recovered public keys should be equal.")
  }
  
  func testPublicKeyRecoveryInvalidHashSize() {
    let signature = secp256k1_ecdsa_recoverable_signature()
    
    let invalidHash = Data([0x01, 0x02, 0x03])
    
    XCTAssertThrowsError(try signature.publicKey(with: invalidHash), "Function should throw an error for an invalid hash size.") { error in
      XCTAssertEqual(error as? secp256k1.Error, secp256k1.Error.secp256k1_invalidHashSize, "Expected error for an invalid hash size.")
    }
  }
}
