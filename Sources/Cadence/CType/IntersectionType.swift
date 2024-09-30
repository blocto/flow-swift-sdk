//
//  File.swift
//  
//
//  Created by Shane Chi on 2024/9/30.
//

import Foundation

public struct IntersectionType: Equatable, Codable {
    public let typeId: String
    public let types: [FType]

    public init(typeId: String, types: [FType]) {
        self.typeId = typeId
        self.types = types
    }

    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case typeId = "typeID"
        case types
    }
}
