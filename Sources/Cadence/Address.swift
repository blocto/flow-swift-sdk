//
//  Address.swift
// 
//  Created by Scott on 2022/5/18.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

/// [n,k,d]-Linear code parameters
/// The linear code used in the account addressing is a [64,45,7]
/// It generates a [64,45]-code, which is the space of Flow account addresses.
///
/// n is the size of the code words in bits,
/// which is also the size of the account addresses in bits.
private let linearCodeN = 64

public struct Address: Equatable, Hashable {

    /// the size of an account address in bytes.
    public static let length = (linearCodeN + 7) >> 3

    public static let emptyAddress = Address(data: Data())

    public let data: Data

    public var bytes: [UInt8] {
        data.bytes
    }

    public var hexString: String {
        data.toHexString()
    }

    public var hexStringWithPrefix: String {
        var result = "0x"
        if data.count < Self.length {
            let zeroPadding = Data(repeating: 0, count: Self.length - data.count)
            result += zeroPadding.toHexString()
        }
        result += data.toHexString()
        return result
    }

    /// If b is larger than 8, b will be cropped from the left.
    /// If b is smaller than 8, b will be appended by zeroes at the front.
    public init(data: Data) {
        self.data = data.normalized
    }

    public init(hexString: String) {
        self.init(data: Data(hex: hexString.fixedHexString))
    }
}

// MARK: - Codable
extension Address: Codable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        data = try container.decodeHexString().normalized
    }
}

// MARK: - CustomStringConvertible

extension Address: CustomStringConvertible {

    public var description: String {
        "0x" + hexString
    }
}

// MARK: - Data

private extension Data {

    var normalized: Data {
        switch count {
        case 0..<Address.length:
            return Data(repeating: 0, count: Address.length - count) + self
        case Address.length:
            return self
        default:
            return self[(count - Address.length) ..< count]
        }
    }
}
