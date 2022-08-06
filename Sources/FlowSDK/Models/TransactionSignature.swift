//
//  TransactionSignature.swift
// 
//  Created by Scott on 2022/5/22.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation
import Cadence

extension Transaction {

    /// A signature associated with a specific account key.
    public struct Signature: Equatable {
        public var address: Address
        public var signerIndex: Int
        public let keyIndex: Int
        public let signature: Data

        public init(
            address: Address,
            signerIndex: Int,
            keyIndex: Int,
            signature: Data
        ) {
            self.address = address
            self.signerIndex = signerIndex
            self.keyIndex = keyIndex
            self.signature = signature
        }
    }
}

extension Transaction.Signature: RLPDecodable {

    public init(rlpItem: RLPItem) throws {
        let items = try rlpItem.getListItems()
        guard items.count == 3 else {
            throw RLPDecodingError.invalidType(rlpItem, type: Self.self)
        }

        self.address = Address.emptyAddress
        self.signerIndex = Int(try UInt(rlpItem: items[0]))
        self.keyIndex = Int(try UInt(rlpItem: items[1]))
        self.signature = try Data(rlpItem: items[2])
    }
}

extension Transaction.Signature: RLPEncodableList {

    public var rlpList: RLPEncoableArray {
        [
            UInt(signerIndex),
            UInt(keyIndex),
            signature
        ]
    }
}
