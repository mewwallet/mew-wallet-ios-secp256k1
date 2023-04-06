//
//  Array+UInt8+SecRandomCopyBytes.Tests.swift
//  mew-wallet-ios-secp256k1
//
//  Created by Mikhail Nikanorov
//  Copyright © 2023 MyEtherWallet Inc. All rights reserved.
//

import XCTest
@testable import mew_wallet_ios_secp256k1

final class Array_UInt8_SecRandomCopyBytes_Tests: XCTestCase {
  // Test if the generated array has the correct length.
  func testSecRandomLength() throws {
    let length: Int = 32
    let randomBytes = try [UInt8].secRandom(length: length)
    XCTAssertEqual(randomBytes.count, Int(length), "Generated array should have the correct length.")
  }
  
  // Test if the generated array has unique values.
  func testSecRandomUniqueness() throws {
    let length: Int = 32
    let randomBytes1 = try [UInt8].secRandom(length: length)
    let randomBytes2 = try [UInt8].secRandom(length: length)
    XCTAssertNotEqual(randomBytes1, randomBytes2, "Generated arrays should have unique values.")
  }
  
  // Test if the function throws an error for an invalid length.
  func testSecRandomError() {
    XCTAssertThrowsError(try [UInt8].secRandom(length: -1), "Function should throw an error for an invalid length.")
  }
}
