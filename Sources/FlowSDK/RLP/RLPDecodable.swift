//
//  RLPDecodable.swift
//
//  Created by Scott on 2022/8/5.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation
import BigInt

public protocol RLPDecodable {
    init(rlpItem: RLPItem) throws
}

// MARK: - Data

extension Data: RLPDecodable {

    public init(rlpItem: RLPItem) throws {
        switch rlpItem {
        case .empty:
            self = Data()
        case let .data(data):
            self = data
        case .list:
            throw RLPDecodingError.invalidType(rlpItem, type: Self.self)
        }
    }

}

// MARK: - Unsigned Integer

extension UInt: RLPDecodable {

    public init(rlpItem: RLPItem) throws {
        self = UInt(try BigUInt(rlpItem: rlpItem))
    }
}

extension UInt8: RLPDecodable {

    public init(rlpItem: RLPItem) throws {
        self = UInt8(try BigUInt(rlpItem: rlpItem))
    }
}

extension UInt16: RLPDecodable {

    public init(rlpItem: RLPItem) throws {
        self = UInt16(try BigUInt(rlpItem: rlpItem))
    }
}

extension UInt32: RLPDecodable {

    public init(rlpItem: RLPItem) throws {
        self = UInt32(try BigUInt(rlpItem: rlpItem))
    }
}

extension UInt64: RLPDecodable {

    public init(rlpItem: RLPItem) throws {
        self = UInt64(try BigUInt(rlpItem: rlpItem))
    }
}

extension BigUInt: RLPDecodable {

    public init(rlpItem: RLPItem) throws {
        switch rlpItem {
        case .empty, .list:
            throw RLPDecodingError.invalidType(rlpItem, type: Self.self)
        case let .data(data):
            self = BigUInt(data)
        }
    }
}

// MARK: - String

extension String: RLPDecodable {

    public init(rlpItem: RLPItem) throws {
        switch rlpItem {
        case .empty, .list:
            throw RLPDecodingError.invalidType(rlpItem, type: Self.self)
        case let .data(data):
            self = String(data: data, encoding: .utf8) ?? ""
        }
    }
}

// MARK: - Bool

extension Bool: RLPDecodable {

    public init(rlpItem: RLPItem) throws {
        switch rlpItem {
        case .empty, .list:
            throw RLPDecodingError.invalidType(rlpItem, type: Self.self)
        case let .data(data):
            switch data.count {
            case 0:
                self = false
            case 1:
                self = (data[0] == 1)
            default:
                throw RLPDecodingError.invalidType(rlpItem, type: Self.self)
            }
        }
    }
}
