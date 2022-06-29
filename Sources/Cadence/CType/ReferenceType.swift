//
//  ReferenceType.swift
// 
//  Created by Scott on 2022/6/22.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

public struct ReferenceType: Equatable, Codable {
    public let authorized: Bool
    public let type: CType

    public init(authorized: Bool, type: CType) {
        self.authorized = authorized
        self.type = type
    }
}
