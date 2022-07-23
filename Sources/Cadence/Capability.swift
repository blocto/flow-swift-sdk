//
//  Capability.swift
// 
//  Created by Scott on 2022/5/20.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

/// https://docs.onflow.org/cadence/json-cadence-spec/#capability
public struct Capability: Codable, Equatable {

    public let path: String
    public let address: Address
    public let borrowType: FType

    public init(
        path: String,
        address: Address,
        borrowType: FType
    ) {
        self.path = path
        self.address = address
        self.borrowType = borrowType
    }
}
