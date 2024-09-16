//
//  ReferenceType.swift
// 
//  Created by Scott on 2022/6/22.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

public struct ReferenceType: Equatable, Codable {
    public let authorization: Authorization
    public let type: FType

    public init(authorization: Authorization, type: FType) {
        self.authorization = authorization
        self.type = type
    }
}

public extension ReferenceType {
    struct Authorization: Codable, Equatable {
        public let kind: AuthorizationKind

        public init(kind: AuthorizationKind) {
            self.kind = kind
        }
    }

    enum AuthorizationKind: String, Codable {
        case unauthorized = "Unauthorized"
        case entitlementMapAuthorization = "EntitlementMapAuthorization"
        case entitlementConjunctionSet = "EntitlementConjunctionSet"
        case entitlementDisjunctionSet = "EntitlementDisjunctionSet"
    }
}
