//
//  CompositeType.swift
// 
//  Created by Scott on 2022/6/21.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

public class CompositeType: Codable {
    public let type: String
    public let typeId: String
    public var initializers: [InitializerType]
    public var fields: [FieldType]

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

    // MARK: Codable

    enum CodingKeys: String, CodingKey {
        case type
        case typeId = "typeID"
        case initializers
        case fields
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(String.self, forKey: .type)
        self.typeId = try container.decode(String.self, forKey: .typeId)
        self.initializers = [] // must call decodePossibleRepeatedProperties later
        self.fields = [] // must call decodePossibleRepeatedProperties later
    }

    public func decodeFieldTypes(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        initializers = try container.decode([InitializerType].self, forKey: .initializers)
        fields = try container.decode([FieldType].self, forKey: .fields)
    }
}

// MARK: - Equatable

extension CompositeType: Equatable {

    public static func == (lhs: CompositeType, rhs: CompositeType) -> Bool {
        lhs.type == rhs.type &&
        lhs.typeId == rhs.typeId
    }
}
