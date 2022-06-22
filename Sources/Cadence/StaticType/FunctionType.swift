//
//  FunctionType.swift
// 
//  Created by Scott on 2022/6/21.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

public struct FunctionType: Equatable {
    public let typeId: String
    public let parameters: [ParameterType]
    public let `return`: StaticType

    public init(typeId: String, parameters: [ParameterType], return: StaticType) {
        self.typeId = typeId
        self.parameters = parameters
        self.return = `return`
    }
}

// MARK: - Codable

extension FunctionType: Codable {

    enum CodingKeys: String, CodingKey {
        case typeId = "typeID"
        case parameters
        case `return`
    }
}
