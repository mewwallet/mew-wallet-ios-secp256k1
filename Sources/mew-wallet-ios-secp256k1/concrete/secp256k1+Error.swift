//
//  secp256k1+Error.swift
//  mew-wallet-ios-secp256k1
//
//  Created by Mikhail Nikanorov
//  Copyright © 2023 MyEtherWallet Inc. All rights reserved.
//

import Foundation

public struct secp256k1 { 
  public enum Error: LocalizedError, Equatable {
    /// This error indicates that the length provided to the `SecRandomCopyBytes` function is invalid.
    case secRandomCopyBytesBadLength
    /// This error occurs when the `SecRandomCopyBytes` function fails to generate cryptographically secure random data. The associated Int32 value represents the error code returned by the function.
    case secRandomCopyBytesError(code: Int32)
    /// This error occurs when the `secp256k1_context_randomize` function fails to randomize a secp256k1 context with a cryptographically secure seed.
    case secp256k1_randomizeError
    /// This error indicates that the provided private key data is invalid, likely due to an incorrect size (it should be 32 bytes long).
    case secp256k1_invalidPrivateKey
    /// This error indicates that the provided public key data is invalid, either due to an incorrect size or an invalid format.
    case secp256k1_invalidPublicKey
    /// This error occurs when the provided hash data has an incorrect size (it should be 32 bytes long).
    case secp256k1_invalidHashSize
    /// This error occurs when the provided signature data has an incorrect size (it should be 64 bytes long).
    case secp256k1_invalidSignatureSize
    /// This error indicates that the `secp256k1_ecdsa_recoverable_signature_parse_compact` function failed to parse a signature from the given data.
    case secp256k1_signatureParseFailure
    /// This error occurs when the `secp256k1_ecdsa_sign_recoverable` function fails to generate a signature.
    case secp256k1_signFailure
    /// This error occurs when the `secp256k1_ecdsa_recover` function fails to recover a public key from a recoverable signature.
    case secp256k1_recoverFailure
    /// This error occurs when the `secp256k1_ec_pubkey_serialize` function fails to serialize a public key.
    case secp256k1_serializeFailure
    /// This error occurs when the `secp256k1_ec_pubkey_tweak_mul` function fails to multiply a public key by a scalar value.
    case secp256k1_tweakMulFailure
  }
}
