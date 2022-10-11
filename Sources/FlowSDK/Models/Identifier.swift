//
//  Identifier.swift
//
//  Created by Scott on 2022/5/18.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation
#if os(Linux)
import Crypto

extension Data {
    init(hex: String) {
        self.init(Array<UInt8>(hex: hex))
    }
}
#else
import CryptoSwift
#endif

public struct Identifier: Equatable {

    public static let empty = Identifier(data: Data(repeating: 0, count: 32))

    public let data: Data

    public var hexString: String {
        data.toHexString()
    }

    public init(data: Data) {
        self.data = data
    }

    public init(hexString: String) {
        self.init(data: Data(hex: hexString))
    }
}

// MARK: - CustomStringConvertible
extension Identifier: CustomStringConvertible {

    public var description: String {
        hexString
    }
}

// MARK: - ExpressibleByStringLiteral
extension Identifier: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.init(hexString: value)
    }
}
