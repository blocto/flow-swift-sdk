//
//  ParameterType.swift
// 
//  Created by Scott on 2022/6/21.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

public struct ParameterType: Equatable, Codable {
    public let label: String
    public let id: String
    public let type: FType

    public init(
        label: String,
        id: String,
        type: FType
    ) {
        self.label = label
        self.id = id
        self.type = type
    }
}
