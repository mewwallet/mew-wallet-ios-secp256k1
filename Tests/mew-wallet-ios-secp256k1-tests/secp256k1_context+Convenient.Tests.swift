//
//  secp256k1_context+Convenient.Tests.swift
//  mew-wallet-ios-secp256k1
//
//  Created by Mikhail Nikanorov
//  Copyright © 2023 MyEtherWallet Inc. All rights reserved.
//

import XCTest
@testable import mew_wallet_ios_secp256k1
import mew_wallet_ios_secp256k1_lib

final class secp256k1_context_Convenient_Tests: XCTestCase {
  func testSignContext() throws {
    let signContext = try secp256k1_context()
    
    XCTAssertNotNil(signContext)
    
    let privateKey = secp256k1_prvkey(rawValue: Data(repeating: 1, count: 32))!
    var publicKey = try privateKey.pubkey
    let message = Data(repeating: 2, count: 32)
    
    var signature = secp256k1_ecdsa_signature()
    
    let signingResult = secp256k1_ecdsa_sign(signContext.rawValue, &signature, message.bytes, privateKey.rawValue.bytes, nil, nil)
    
    XCTAssertEqual(signingResult, 1)
    
    let verificationResult = secp256k1_ecdsa_verify(signContext.rawValue, &signature, message.bytes, &publicKey)
    
    XCTAssertEqual(verificationResult, 1)
  }
}
