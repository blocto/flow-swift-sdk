//
//  Composite.swift
// 
//  Created by Scott on 2022/5/20.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

/// https://docs.onflow.org/cadence/json-cadence-spec/#composites-struct-resource-event-contract-enum
public struct Composite: Codable, Equatable {

    public let id: String
    public let fields: [Field]

    public init(id: String, fields: [Field]) {
        self.id = id
        self.fields = fields
    }
}

public typealias CompositeStruct = Composite
public typealias CompositeResource = Composite
public typealias CompositeEvent = Composite
public typealias CompositeContract = Composite
public typealias CompositeEnum = Composite

// MARK: - Field
extension Composite {

    public struct Field: Codable, Equatable {
        public let name: String
        public let value: Value

        public init(name: String, value: Value) {
            self.name = name
            self.value = value
        }
    }
}
