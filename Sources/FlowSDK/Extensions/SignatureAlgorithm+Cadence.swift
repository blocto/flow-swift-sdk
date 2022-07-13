//
//  SignatureAlgorithm+Cadence.swift
//
//  Created by Scott on 2022/7/12.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation
import Crypto

extension SignatureAlgorithm {

    public var cadenceValue: UInt8 {
        switch self {
        case .ecdsaP256:
            return 1
        case .ecdsaSecp256k1:
            return 2
        }
    }
}
