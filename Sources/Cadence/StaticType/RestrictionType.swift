//
//  RestrictionType.swift
// 
//  Created by Scott on 2022/6/21.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

public struct RestrictionType: Equatable {
    public let typeId: String
    public let type: StaticType
    public let restrictions: [StaticType]

    public init(
        typeId: String,
        type: StaticType,
        restrictions: [StaticType]
    ) {
        self.typeId = typeId
        self.type = type
        self.restrictions = restrictions
    }
}

// MARK: - Codable

extension RestrictionType: Codable {

    enum CodingKeys: String, CodingKey {
        case typeId = "typeID"
        case type
        case restrictions
    }
}
