//
//  RestrictionType.swift
// 
//  Created by Scott on 2022/6/21.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

public class RestrictionType: Codable {
    public let typeId: String
    public var type: FType
    public var restrictions: [FType]

    public init(
        typeId: String,
        type: FType,
        restrictions: [FType]
    ) {
        self.typeId = typeId
        self.type = type
        self.restrictions = restrictions
    }

    // MARK: Codable

    enum CodingKeys: String, CodingKey {
        case typeId = "typeID"
        case type
        case restrictions
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.typeId = try container.decode(String.self, forKey: .typeId)
        self.type = .bool // must call decodePossibleRepeatedProperties later
        self.restrictions = [] // must call decodePossibleRepeatedProperties later
    }

    public func decodePossibleRepeatedProperties(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeFType(userInfo: decoder.userInfo, forKey: .type)
        restrictions = try container.decode([FType].self, forKey: .restrictions)
    }
}

// MARK: - Equatable

extension RestrictionType: Equatable {

    public static func == (lhs: RestrictionType, rhs: RestrictionType) -> Bool {
        lhs.typeId == rhs.typeId &&
        lhs.type == rhs.type
    }
}
