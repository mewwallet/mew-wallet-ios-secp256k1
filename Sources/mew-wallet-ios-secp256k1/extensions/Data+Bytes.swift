//
//  Data+Bytes.swift
//  mew-wallet-ios-secp256k1
//
//  Created by Mikhail Nikanorov
//  Copyright © 2023 MyEtherWallet Inc. All rights reserved.
//

import Foundation

/// This extension adds a convenience property to the `Data` struct,
/// allowing easy conversion to an array of `UInt8` elements.
extension Data {
  internal var bytes: [UInt8] { [UInt8](self) }
}
