//
//  PublicKey.swift
// 
//  Created by Scott on 2022/5/22.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation
import CryptoKit
import CryptoSwift
import secp256k1Swift

public struct PublicKey {

    public let data: Data

    public let algorithm: SignatureAlgorithm

    public var size: Int {
        data.count
    }

    public var hexString: String {
        data.toHexString()
    }

    private let implementation: Implementation

    public init(data: Data, signatureAlgorithm: SignatureAlgorithm) throws {
        self.algorithm = signatureAlgorithm

        switch signatureAlgorithm {
        case .ecdsaP256:
            self.data = data
            self.implementation = .ecdsaP256(try P256.Signing.PublicKey(rawRepresentation: data))
        case .ecdsaSecp256k1:
            let rawData: Data
            switch data.count {
            case secp256k1.Format.compressed.length, secp256k1.Format.compressed.length - 1:
                throw Error.unsupportedCompressFormat
            case secp256k1.Format.uncompressed.length:
                rawData = data
                self.data = data.dropFirst()
            case secp256k1.Format.uncompressed.length - 1:
                self.data = data
                rawData = Data([0x04]) + data
            default:
                throw Error.incorrectKeySize
            }

            let key = secp256k1.Signing.PublicKey(
                rawRepresentation: rawData,
                xonly: Data(),
                keyParity: 0,
                format: .uncompressed)
            self.implementation = .ecdsaSecp256k1(key)
        }
    }

    public func verify(signature: Data, message: Data, hashAlgorithm: HashAlgorithm) throws -> Bool {
        switch implementation {
        case let .ecdsaP256(key):
            let digest = hashAlgorithm.getDigest(message: message)
            let ecdsaSignature = try P256.Signing.ECDSASignature(rawRepresentation: signature)
            return key.isValidSignature(ecdsaSignature, for: digest)
        case let .ecdsaSecp256k1(key):
            let digest = hashAlgorithm.getDigest(message: message)
            let ecdsaSignature = try secp256k1.Signing.ECDSASignature(rawRepresentation: signature)
            return key.ecdsa.isValidSignature(ecdsaSignature, for: digest)
        }
    }

}

// MARK: - Equatable, Hashable

extension PublicKey: Equatable, Hashable {

    public static func == (lhs: PublicKey, rhs: PublicKey) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(data)
        hasher.combine(algorithm)
    }

}

// MARK: - Error

extension PublicKey {

    enum Error: Swift.Error {
        case unsupportedCompressFormat
        case incorrectKeySize
    }
}

// MARK: - CustomStringConvertible

extension PublicKey: CustomStringConvertible {

    public var description: String {
        hexString
    }
}

// MARK: - Implementation

extension PublicKey {

    private enum Implementation {
        case ecdsaP256(P256.Signing.PublicKey)
        case ecdsaSecp256k1(secp256k1.Signing.PublicKey)
    }
}
