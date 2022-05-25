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
        public let address: Address
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

extension Transaction.Signature: RLPEncodableList {

    public var rlpList: RLPArray {
        [
            UInt(signerIndex),
            UInt(keyIndex),
            signature
        ]
    }
}
