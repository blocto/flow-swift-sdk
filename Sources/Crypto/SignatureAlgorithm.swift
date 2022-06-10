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
}
