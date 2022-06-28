//
//  FunctionType.swift
// 
//  Created by Scott on 2022/6/21.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

public class FunctionType: Codable {
    public let typeId: String
    public var parameters: [ParameterType]
    public var `return`: StaticType

    public init(
        typeId: String,
        parameters: [ParameterType] = [],
        return: StaticType = .void
    ) {
        self.typeId = typeId
        self.parameters = parameters
        self.return = `return`
    }

    // MARK: Codable

    enum CodingKeys: String, CodingKey {
        case typeId = "typeID"
        case parameters
        case `return`
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.typeId = try container.decode(String.self, forKey: .typeId)
        self.parameters = [] // must call decodePossibleRepeatedProperties later
        self.return = .bool // must call decodePossibleRepeatedProperties later
    }

    public func decodePossibleRepeatedProperties(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        parameters = try container.decode([ParameterType].self, forKey: .parameters)
        `return` = try container.decodeStaticType(userInfo: decoder.userInfo, forKey: .return)
    }
}

// MARK: - Equatable

extension FunctionType: Equatable {

    public static func == (lhs: FunctionType, rhs: FunctionType) -> Bool {
        lhs.typeId == rhs.typeId &&
        lhs.parameters == rhs.parameters &&
        lhs.return == rhs.return
    }
}
