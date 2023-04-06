//
//  Data+Sign.Tests.swift
//  mew-wallet-ios-secp256k1
//
//  Created by Mikhail Nikanorov
//  Copyright © 2023 MyEtherWallet Inc. All rights reserved.
//

import XCTest
@testable import mew_wallet_ios_secp256k1

final class Data_Sign_Tests: XCTestCase {
  func testSign() throws {
    let privateKey = try secp256k1_prvkey(data: Data([UInt8](repeating: 1, count: 32)))
    let hash = Data([UInt8](repeating: 2, count: 32))
    
    let signature = try hash.sign(key: privateKey)
    let publicKey = try privateKey.pubkey
    
    let recoveredPublicKey = try signature.publicKey(with: hash)
    XCTAssertEqual(publicKey.rawValue, recoveredPublicKey.rawValue)
    
    let signatureWithEntropy = try hash.sign(key: privateKey, extraEntropy: true)
    XCTAssertNotEqual(signature.rawValue, signatureWithEntropy.rawValue)
    
    let recoveredPublicKeyWithEntropy = try signatureWithEntropy.publicKey(with: hash)
    XCTAssertEqual(publicKey.rawValue, recoveredPublicKeyWithEntropy.rawValue)
  }
}
