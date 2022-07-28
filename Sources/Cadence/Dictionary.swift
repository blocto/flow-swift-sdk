//
//  Dictionary.swift
// 
//  Created by Scott on 2022/5/20.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

/// https://docs.onflow.org/cadence/json-cadence-spec/#dictionary
public struct Dictionary: Codable, Equatable {

    public let key: Argument
    public let value: Argument

    public init(key: Argument, value: Argument) {
        self.key = key
        self.value = value
    }
}
