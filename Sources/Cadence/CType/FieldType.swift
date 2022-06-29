//
//  FieldType.swift
// 
//  Created by Scott on 2022/6/21.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

public struct FieldType: Equatable, Codable {
    public let id: String
    public let type: CType

    public init(id: String, type: CType) {
        self.id = id
        self.type = type
    }
}
