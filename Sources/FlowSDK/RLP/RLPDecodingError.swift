//
//  RLPDecodingError.swift
//
//  Created by Scott on 2022/8/6.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

public enum RLPDecodingError: Swift.Error {
    case invalidFormat
    case invalidType(RLPItem, type: Any.Type)
    case notListType
}
