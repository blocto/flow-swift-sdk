//
//  HashAlgorithm.swift
//
//  Created by Scott on 2022/7/24.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation
import Cadence

public extension HashAlgorithm {

    var cadenceArugment: Cadence.Argument {
        .enum(
            id: "HashAlgorithm",
            fields: [
                .init(
                    name: "rawValue",
                    value: .uint8(cadenceRawValue)
                )
            ]
        )
    }

    var cadenceRawValue: UInt8 {
        switch self {
        case .sha2_256:
            return 1
        case .sha3_256:
            return 3
        }
    }

}
