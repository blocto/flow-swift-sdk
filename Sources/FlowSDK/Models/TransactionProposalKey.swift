//
//  TransactionProposalKey.swift
// 
//  Created by Scott on 2022/5/22.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation
import Cadence
#if !COCOAPODS
import Protobuf
#endif

extension Transaction {

    /// The key that specifies the proposal key and sequence number for a transaction.
    public struct ProposalKey: Equatable {
        public let address: Address
        public let keyIndex: Int
        public let sequenceNumber: UInt64

        public init(address: Address, keyIndex: Int, sequenceNumber: UInt64) {
            self.address = address
            self.keyIndex = keyIndex
            self.sequenceNumber = sequenceNumber
        }

        init(_ value: Flow_Entities_Transaction.ProposalKey) {
            self.address = Address(data: value.address)
            self.keyIndex = Int(value.keyID)
            self.sequenceNumber = value.sequenceNumber
        }
    }

}
