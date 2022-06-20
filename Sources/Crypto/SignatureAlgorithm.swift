//
//  SignatureAlgorithm.swift
// 
//  Created by Scott on 2022/6/5.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

public enum SignatureAlgorithm: UInt32, RawRepresentable {
    case ecdsaP256 = 2
    case ecdsaSecp256k1 = 3
    
    public var cadenceValue: UInt8 {
        switch self {
        case .ecdsaP256:
            return 1
        case .ecdsaSecp256k1:
            return 2
        }
    }
}
