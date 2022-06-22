//
//  Path.swift
// 
//  Created by Scott on 2022/5/20.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

/// https://docs.onflow.org/cadence/json-cadence-spec/#path
public struct Path: Codable, Equatable {

    public let domain: Domain
    public let identifier: String

    public init(domain: Domain, identifier: String) {
        self.domain = domain
        self.identifier = identifier
    }
}

// MARK: - Domain

extension Path {

    public enum Domain: String, Codable {
        case storage
        case `private`
        case `public`
    }
}
