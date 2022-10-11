//
//  PrivateKey.swift
// 
//  Created by Scott on 2022/5/22.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation
import CryptoKit
import CryptoSwift
import secp256k1

public struct PrivateKey {

    public let data: Data

    public let algorithm: SignatureAlgorithm

    public let publicKey: PublicKey

    private let implementation: Implementation

    public var size: Int {
        data.count
    }

    public var hexString: String {
        data.toHexString()
    }

    public init(signatureAlgorithm: SignatureAlgorithm) throws {
        self.algorithm = signatureAlgorithm

        switch signatureAlgorithm {
        case .ecdsaP256:
            let key = P256.Signing.PrivateKey(compactRepresentable: false)
            self.data = key.rawRepresentation
            self.publicKey = try PublicKey(data: key.publicKey.rawRepresentation, signatureAlgorithm: .ecdsaP256)
            self.implementation = .ecdsaP256(key)
        case .ecdsaSecp256k1:
            let key = try secp256k1.Signing.PrivateKey(format: .uncompressed)
            self.data = key.rawRepresentation
            let rawPublicKey = key.publicKey.rawRepresentation
            self.publicKey = try PublicKey(data: rawPublicKey.dropFirst(), signatureAlgorithm: .ecdsaSecp256k1)
            self.implementation = .ecdsaSecp256k1(key)
        }
    }

    public init(data: Data, signatureAlgorithm: SignatureAlgorithm) throws {
        self.data = data
        self.algorithm = signatureAlgorithm

        switch signatureAlgorithm {
        case .ecdsaP256:
            let key = try P256.Signing.PrivateKey(rawRepresentation: data)
            self.publicKey = try PublicKey(data: key.publicKey.rawRepresentation, signatureAlgorithm: .ecdsaP256)
            self.implementation = .ecdsaP256(key)
        case .ecdsaSecp256k1:
            let key = try secp256k1.Signing.PrivateKey(rawRepresentation: data, format: .uncompressed)
            let rawPublicKey = key.publicKey.rawRepresentation
            self.publicKey = try PublicKey(data: rawPublicKey.dropFirst(), signatureAlgorithm: .ecdsaSecp256k1)
            self.implementation = .ecdsaSecp256k1(key)
        }
    }

    /// Generates a signature.
    /// - Parameter data: The data to sign.
    /// - Parameter hashAlgorithm: The hash algorithm.
    /// - Returns: The ECDSA Signature.
    /// - Throws: If there is a failure producing the signature.
    public func sign(message: Data, hashAlgorithm: HashAlgorithm) throws -> Data {
        switch implementation {
        case let .ecdsaP256(key):
            let digest = hashAlgorithm.getDigest(message: message)
            return try key.signature(for: digest).rawRepresentation
        case let .ecdsaSecp256k1(key):
            let digest = hashAlgorithm.getDigest(message: message)
            return try key.ecdsa.signature(for: digest).compactRepresentation
        }
    }
}

// MARK: - Equatable, Hashable

extension PrivateKey: Equatable, Hashable {

    public static func == (lhs: PrivateKey, rhs: PrivateKey) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(data)
        hasher.combine(algorithm)
    }

}

// MARK: - Error

extension PrivateKey {

    public enum Error: Swift.Error {
        case insufficientSeedLength
    }
}

// MARK: - CustomStringConvertible

extension PrivateKey: CustomStringConvertible {

    public var description: String {
        hexString
    }
}

// MARK: - Implementation

extension PrivateKey {

    private enum Implementation {
        case ecdsaP256(P256.Signing.PrivateKey)
        case ecdsaSecp256k1(secp256k1.Signing.PrivateKey)
    }
}
