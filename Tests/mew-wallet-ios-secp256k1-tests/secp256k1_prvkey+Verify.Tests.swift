//
//  secp256k1_prvkey+Verify.Tests.swift
//  mew-wallet-ios-secp256k1
//
//  Created by Mikhail Nikanorov
//  Copyright © 2023 MyEtherWallet Inc. All rights reserved.
//


import XCTest
@testable import mew_wallet_ios_secp256k1
import mew_wallet_ios_secp256k1_lib

final class secp256k1_prvkey_Verify_Tests: XCTestCase {
  func testValidPrivateKey() throws {
    let privateKeyData = Data([UInt8](repeating: 2, count: 32))
    let privateKey = try secp256k1_prvkey(data: privateKeyData)
    
    XCTAssertNoThrow(try privateKey.verify(), "A valid private key should not throw an error.")
  }
  
  func testInvalidPrivateKey() throws {
    let invalidPrivateKeyData = Data([UInt8](repeating: 0, count: 32))
    let invalidPrivateKey = try secp256k1_prvkey(data: invalidPrivateKeyData)
    
    XCTAssertThrowsError(try invalidPrivateKey.verify(), "An invalid private key should throw an error.") { error in
      XCTAssertEqual(error as? secp256k1.Error, secp256k1.Error.secp256k1_invalidPrivateKey)
    }
  }
}
