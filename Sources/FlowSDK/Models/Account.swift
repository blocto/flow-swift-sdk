//
//  Account.swift
// 
//  Created by Scott on 2022/5/22.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation
import Cadence

/// An account on the Flow network.
public struct Account: Equatable {

    public let address: Address

    public let balance: UInt64

    public let code: Data

    public let keys: [AccountKey]

    public let contracts: [String: Data]

    public init(
        address: Address,
        balance: UInt64,
        code: Data,
        keys: [AccountKey],
        contracts: [String: Data]
    ) {
        self.address = address
        self.balance = balance
        self.code = code
        self.keys = keys
        self.contracts = contracts
    }

    init(_ value: Flow_Entities_Account) throws {
        self.address = Address(data: value.address)
        self.balance = value.balance
        self.code = value.code
        self.keys = try value.keys.map { try AccountKey($0) }
        self.contracts = value.contracts
    }
}

/// A public key associated with an account.
public struct AccountKey: Equatable {

    /// The total key weight required to authorize access to an account.
    public static let weightThreshold = 1000

    public let index: Int

    public let publicKey: PublicKey

    public let signatureAlgorithm: SignatureAlgorithm

    public let hashAlgorithm: HashAlgorithm

    public let weight: Int

    public let sequenceNumber: UInt64

    public let revoked: Bool

    public init(
        index: Int,
        publicKey: PublicKey,
        signatureAlgorithm: SignatureAlgorithm,
        hashAlgorithm: HashAlgorithm,
        weight: Int,
        sequenceNumber: UInt64,
        revoked: Bool = false
    ) {
        self.index = index
        self.publicKey = publicKey
        self.signatureAlgorithm = signatureAlgorithm
        self.hashAlgorithm = hashAlgorithm
        self.weight = weight
        self.sequenceNumber = sequenceNumber
        self.revoked = revoked
    }

    init(_ value: Flow_Entities_AccountKey) throws {
        self.index = Int(value.index)
        guard let signatureAlgorithm = SignatureAlgorithm(rawValue: value.signAlgo) else {
            throw Error.unsupportedSignatureAlgorithm
        }
        self.signatureAlgorithm = signatureAlgorithm
        guard let hashAlgorithm = HashAlgorithm(rawValue: value.hashAlgo) else {
            throw Error.unsupportedHashAlgorithm
        }
        self.hashAlgorithm = hashAlgorithm
        self.publicKey = try PublicKey(data: value.publicKey, signatureAlgorithm: signatureAlgorithm)
        self.weight = Int(value.weight)
        self.sequenceNumber = UInt64(value.sequenceNumber)
        self.revoked = value.revoked
    }

    public enum Error: Swift.Error {
        case unsupportedSignatureAlgorithm
        case unsupportedHashAlgorithm
    }

}
