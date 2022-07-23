//
//  ReferenceType.swift
// 
//  Created by Scott on 2022/6/22.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

public struct ReferenceType: Equatable, Codable {
    public let authorized: Bool
    public let type: FType

    public init(authorized: Bool, type: FType) {
        self.authorized = authorized
        self.type = type
    }
}
