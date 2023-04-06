//
//  secp256k1_ecdsa_recoverable_signature+Data.Tests.swift
//  mew-wallet-ios-secp256k1
//
//  Created by Mikhail Nikanorov
//  Copyright © 2023 MyEtherWallet Inc. All rights reserved.
//

import XCTest
@testable import mew_wallet_ios_secp256k1

final class secp256k1_ecdsa_recoverable_signature_Data_Tests: XCTestCase {
  func testRawPropertyConversion() {
    // Create an example secp256k1_ecdsa_recoverable_signature instance.
    // swiftlint:disable:next large_tuple
    let data: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
               UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
               UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
               UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
               UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
               UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
               UInt8, UInt8, UInt8, UInt8, UInt8) = (
                0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A,
                0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x10, 0x11, 0x12, 0x13, 0x14,
                0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E,
                0x1F, 0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28,
                0x29, 0x2A, 0x2B, 0x2C, 0x2D, 0x2E, 0x2F, 0x30, 0x31, 0x32,
                0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C,
                0x3D, 0x3E, 0x3F, 0x40, 0x41
               )
    let expectedData = Data([0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A,
                             0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x10, 0x11, 0x12, 0x13, 0x14,
                             0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E,
                             0x1F, 0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28,
                             0x29, 0x2A, 0x2B, 0x2C, 0x2D, 0x2E, 0x2F, 0x30, 0x31, 0x32,
                             0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C,
                             0x3D, 0x3E, 0x3F, 0x40, 0x41])
    
    let signature = secp256k1_ecdsa_recoverable_signature(data: data)
    
    // Convert the signature to Data using the raw property.
    let signatureData = signature.rawValue
    
    // Verify that the resulting Data object has the correct length.
    XCTAssertEqual(signatureData.count, MemoryLayout.size(ofValue: signature.data))
    
    // Verify that the Data object contains the correct bytes.
    for i in 0..<MemoryLayout.size(ofValue: signature.data) {
      XCTAssertEqual(signatureData[i], expectedData[i])
    }
  }
  
  func testSignatureSerialization() throws {
    let privateKey = try secp256k1_prvkey(data: Data([UInt8](repeating: 1, count: 32)))
    let hash = Data([UInt8](repeating: 2, count: 32))
    let signature = try hash.sign(key: privateKey)
    let serializedSignature = try signature.serialized
    
    let deserializedSignature = try secp256k1_ecdsa_recoverable_signature(data: serializedSignature)
    
    XCTAssertEqual(signature.rawValue, deserializedSignature.rawValue, "The original and deserialized signatures should be equal.")
  }
  
  func testInvalidSignatureSize() {
    let invalidData = Data([UInt8](repeating: 0, count: 64))
    XCTAssertThrowsError(try secp256k1_ecdsa_recoverable_signature(data: invalidData), "Creating a signature with invalid data size should throw an error.") { error in
      XCTAssertEqual(error as? secp256k1.Error, secp256k1.Error.secp256k1_invalidSignatureSize)
    }
  }
}
