//
//  secp256k1_pubkey+Multiply.Tests.swift
//  mew-wallet-ios-secp256k1
//
//  Created by Mikhail Nikanorov
//  Copyright © 2023 MyEtherWallet Inc. All rights reserved.
//


import XCTest
@testable import mew_wallet_ios_secp256k1
import mew_wallet_ios_secp256k1_lib

final class secp256k1_pubkey_Multiply_Tests: XCTestCase {
  func testPubkeyMulPrvkey() throws {
    // Generate a valid private key.
    let privateKeyData = Data([0x3b, 0x7e, 0x1c, 0x8d, 0x18, 0xa2, 0x8b, 0x15, 0x3b, 0x87,
                               0xf6, 0xbb, 0xd0, 0xe1, 0x62, 0xc8, 0xa6, 0xc1, 0xd2, 0xc4,
                               0xf6, 0xf4, 0xe6, 0xa8, 0xd6, 0xe8, 0xf6, 0xc0, 0xe6, 0xe6,
                               0xe6, 0xe6])
    let privateKey = try secp256k1_prvkey(data: privateKeyData)
    
    // Derive the public key from the private key.
    XCTAssertNoThrow(try privateKey.pubkey, "Deriving the public key from a valid private key should not throw an error.")
    let publicKey = try privateKey.pubkey
    
    // Test the multiplication operator between the public key and private key.
    XCTAssertNoThrow(try publicKey * privateKey, "Multiplying the public key by the private key should not throw an error.")
    let multipliedPublicKey = try publicKey * privateKey
    
    // The multiplied public key should not be equal to the original public key.
    XCTAssertNotEqual(publicKey.rawValue, multipliedPublicKey.rawValue, "The multiplied public key should not be equal to the original public key.")
  }
}
