//
//  Collection.swift
// 
//  Created by Scott on 2022/5/18.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

/// A Collection is a list of transactions bundled together for inclusion in a block.
public struct Collection: Equatable {

    public let transactionIds: [Identifier]

    public init(transactionIds: [Identifier]) {
        self.transactionIds = transactionIds
    }

    init(_ value: Flow_Entities_Collection) {
        self.transactionIds = value.transactionIds.map { Identifier(data: $0) }
    }
}

/// A CollectionGuarantee is an attestation signed by the nodes that have guaranteed a collection.
public struct CollectionGuarantee: Equatable {

    public let collectionId: Identifier
}
