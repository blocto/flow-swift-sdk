//
//  RLPEncodable.swift
// 
//  Created by Scott on 2022/5/22.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation
import BigInt

public protocol RLPEncodable {
    var rlpData: Data { get }
}

extension RLPEncodable {

    fileprivate func encodeLength(_ length: UInt64, offset: UInt8) -> Data {
        if length < 56 {
            return Data([UInt8(length) + offset])
        } else {
            let binaryData = length.bigEndianBinaryData
            return Data([UInt8(binaryData.count) + offset + 55]) + binaryData
        }
    }
}

// MARK: - RLPEncoableArray

public typealias RLPEncoableArray = [RLPEncodable]

extension RLPEncoableArray: RLPEncodable {

    public var rlpData: Data {
        get {
            var output = Data()
            for value in self {
                output += value.rlpData
            }
            return encodeLength(UInt64(output.count), offset: 0xc0) + output
        }
    }
}

// MARK: - Data

extension Data: RLPEncodable {

    public var rlpData: Data {
        if count == 1 && self[0] <= 0x7f {
            return self
        } else {
            var output = encodeLength(UInt64(count), offset: 0x80)
            output.append(self)
            return output
        }
    }
}

// MARK: - Unsigned Integer

extension UInt: RLPEncodable {

    public var rlpData: Data {
        BigUInt(self).rlpData
    }
}

extension UInt8: RLPEncodable {

    public var rlpData: Data {
        BigUInt(self).rlpData
    }
}

extension UInt16: RLPEncodable {

    public var rlpData: Data {
        BigUInt(self).rlpData
    }
}

extension UInt32: RLPEncodable {

    public var rlpData: Data {
        BigUInt(self).rlpData
    }
}

extension UInt64: RLPEncodable {

    public var rlpData: Data {
        BigUInt(self).rlpData
    }
}

extension BigUInt: RLPEncodable {

    public var rlpData: Data {
        serialize().rlpData
    }
}

// MARK: - String

extension String: RLPEncodable {

    public var rlpData: Data {
        (data(using: .utf8) ?? Data()).rlpData
    }
}

// MARK: - Bool

extension Bool: RLPEncodable {

    public var rlpData: Data {
        ((self ? 1 : 0) as UInt).rlpData
    }
}

// MARK: - Private

private extension UInt64 {

    var bigEndianBinaryData: Data {
        var value = self
        let bytes: [UInt8] = withUnsafeBytes(of: &value) { Array($0) }.reversed()
        if let index = bytes.firstIndex(where: { $0 != 0x0 }) {
            return Data(bytes[index...])
        } else {
            return Data([0])
        }
    }
}
