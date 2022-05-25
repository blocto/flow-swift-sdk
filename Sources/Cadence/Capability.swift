//
//  CadenceCapability.swift
// 
//  Created by Scott on 2022/5/20.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

/// https://docs.onflow.org/cadence/json-cadence-spec/#capability
public struct Capability: Codable, Equatable {

    public let path: String
    public let address: String
    public let borrowType: String
}
