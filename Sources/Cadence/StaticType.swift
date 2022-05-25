//
//  StaticType.swift
// 
//  Created by Scott on 2022/5/20.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

/// https://docs.onflow.org/cadence/json-cadence-spec/#type
public struct StaticType: Codable, Equatable {
    public let staticType: String
}
