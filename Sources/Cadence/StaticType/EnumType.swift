//
//  EnumType.swift
// 
//  Created by Scott on 2022/6/21.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

public struct EnumType: Equatable {
    public let type: StaticType
    public let typeId: String
    public let fields: [FieldType]

    public init(
        type: StaticType,
        typeId: String,
        fields: [FieldType]
    ) {
        self.type = type
        self.typeId = typeId
        self.fields = fields
    }
}

// MARK: - Codable

extension EnumType: Codable {

    enum CodingKeys: String, CodingKey {
        case type
        case typeId = "typeID"
        case fields
    }
}

