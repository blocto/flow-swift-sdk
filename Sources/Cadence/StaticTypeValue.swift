//
//  StaticTypeValue.swift
// 
//  Created by Scott on 2022/5/20.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

/// https://docs.onflow.org/cadence/json-cadence-spec/#type-value
public struct StaticTypeValue: Codable, Equatable {
    public let staticType: FType

    public init(staticType: FType) {
        self.staticType = staticType
    }
}
