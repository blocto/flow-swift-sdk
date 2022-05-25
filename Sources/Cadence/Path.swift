//
//  CadencePath.swift
// 
//  Created by Scott on 2022/5/20.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

/// https://docs.onflow.org/cadence/json-cadence-spec/#path
public struct Path: Codable, Equatable {

    public let domain: PathType
    public let identifier: String
}

public enum PathType: String, Codable {
    case storage
    case `private`
    case `public`
}
