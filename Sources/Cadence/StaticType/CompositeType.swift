//
//  CompositeType.swift
// 
//  Created by Scott on 2022/6/21.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

public struct CompositeType: Equatable {
    public let type: String
    public let typeId: String
    public let initializers: [InitializerType]
    public let fields: [FieldType]

    public init(
        type: String,
        typeId: String,
        initializers: [InitializerType],
        fields: [FieldType]
    ) {
        self.type = type
        self.typeId = typeId
        self.initializers = initializers
        self.fields = fields
    }

}

// MARK: - Codable
extension CompositeType: Codable {

    enum CodingKeys: String, CodingKey {
        case type
        case typeId = "typeID"
        case initializers
        case fields
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(String.self, forKey: .type)
        self.typeId = try container.decode(String.self, forKey: .typeId)
        self.initializers = try container.decode([InitializerType].self, forKey: .initializers)
        self.fields = try container.decode([FieldType].self, forKey: .fields)
    }

}
