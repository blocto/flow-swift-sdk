//
//  SingleValueDecodingContainerExtension.swift
// 
//  Created by Scott on 2022/5/19.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation
import CryptoSwift

extension SingleValueDecodingContainer {

    func decodeHexString() throws -> Data {
        let hexString = try decode(String.self)
        let data = Data(hex: hexString.fixedHexString)
        return data
    }

}
