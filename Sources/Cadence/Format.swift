//
//  Format.swift
// 
//  Created by Scott on 2022/6/29.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation
import BigInt

enum Format {
    case void
    case `nil`
    case string(String)
    case address(Address)
    case bool(Bool)
    case bigInt(BigInt)
    case bigUInt(BigUInt)
    case int8(Int8)
    case uint8(UInt8)
    case int16(Int16)
    case uint16(UInt16)
    case int32(Int32)
    case uint32(UInt32)
    case int64(Int64)
    case uint64(UInt64)
    case int(Int)
    case uint(UInt)
    case decimal(Decimal)
    case array([String])
    case dictionary([(key: String, value: String)])
    case composite(
        typeId: String,
        fields: [(name: String, value: String)])
    case path(
        domain: String,
        identifier: String)
    case type(FType)
    case capability(
        borrowType: FType,
        address: Address,
        path: String)
}

// MARK: - CustomStringConvertible

extension Format: CustomStringConvertible {

    var description: String {
        switch self {
        case .void:
            return "()"
        case .nil:
            return "nil"
        case let .string(string):
            return string.quoteString
        case let .address(address):
            return address.description
        case let .bool(bool):
            return bool ? "true" : "false"
        case let .bigInt(bigInt):
            return bigInt.description
        case let .bigUInt(bigUInt):
            return bigUInt.description
        case let .int8(int8):
            return String(int8)
        case let .uint8(uint8):
            return String(uint8)
        case let .int16(int16):
            return String(int16)
        case let .uint16(uint16):
            return String(uint16)
        case let .int32(int32):
            return String(int32)
        case let .uint32(uint32):
            return String(uint32)
        case let .int64(int64):
            return String(int64)
        case let .uint64(uint64):
            return String(uint64)
        case let .int(int):
            return String(int)
        case let .uint(uint):
            return String(uint)
        case let .decimal(decimal):
            let elements = decimal.description.split(separator: ".")
            switch elements.count {
            case 1:
                return "\(elements[0]).00000000"
            case 2:
                let paddingZero = String(repeating: "0", count: 8 - elements[1].count)
                return "\(elements[0]).\(elements[1])\(paddingZero)"
            default:
                return decimal.description
            }
        case let .array(array):
            var result = "["
            for (index, string) in array.enumerated() {
                if index > 0 {
                    result += ", "
                }
                result += string
            }
            result += "]"
            return result
        case let .dictionary(pairs):
            var result = "{"
            for (index, pair) in pairs.enumerated() {
                if index > 0 {
                    result += ", "
                }
                result += "\(pair.key): \(pair.value)"
            }
            result += "}"
            return result
        case let .composite(typeId, fields):
            var result = "\(typeId)("
            for (index, pair) in fields.enumerated() {
                if index > 0 {
                    result += ", "
                }
                result += "\(pair.name): \(pair.value)"
            }
            result += ")"
            return result
        case let .path(domain, identifier):
            return "/\(domain)/\(identifier)"
        case let .type(type):
            if type.id == "" {
                return "Type()"
            } else {
                return "Type<\(type.id)>()"
            }
        case let .capability(borrowType, address, path):
            let typeArgument = borrowType.id.isEmpty ? "" : "<\(borrowType.id)>"
            return "Capability\(typeArgument)(address: \(address.hexStringWithPrefix), path: \(path))"
        }
    }

}
