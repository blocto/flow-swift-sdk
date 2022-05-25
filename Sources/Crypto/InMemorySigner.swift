//
//  InMemorySigner.swift
// 
//  Created by Scott on 2022/6/6.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

public struct InMemorySigner: Signer {

    public let privateKey: PrivateKey

    public let hashAlgorithm: HashAlgorithm

    public init(privateKey: PrivateKey, hashAlgorithm: HashAlgorithm) {
        self.privateKey = privateKey
        self.hashAlgorithm = hashAlgorithm
    }

    public var publicKey: PublicKey {
        privateKey.publicKey
    }

    public func sign(message: Data) throws -> Data {
        try privateKey.sign(message: message, hashAlgorithm: hashAlgorithm)
    }
}
