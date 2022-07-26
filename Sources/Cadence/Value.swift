//
//  Value.swift
// 
//  Created by Scott on 2022/5/18.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation
import BigInt
import Combine

public enum Value: Equatable {
    case void
    indirect case optional(Value?)
    case bool(Bool)
    case string(String)
    case address(Address)
    case int(BigInt)
    case uint(BigUInt)
    case int8(Int8)
    case uint8(UInt8)
    case int16(Int16)
    case uint16(UInt16)
    case int32(Int32)
    case uint32(UInt32)
    case int64(Int64)
    case uint64(UInt64)
    case int128(BigInt)
    case uint128(BigUInt)
    case int256(BigInt)
    case uint256(BigUInt)
    case word8(UInt8)
    case word16(UInt16)
    case word32(UInt32)
    case word64(UInt64)
    case fix64(Decimal)
    case ufix64(Decimal)
    indirect case array([Value])
    indirect case dictionary([Dictionary])
    indirect case `struct`(CompositeStruct)
    indirect case resource(CompositeResource)
    indirect case event(CompositeEvent)
    indirect case contract(CompositeContract)
    indirect case `enum`(CompositeEnum)
    case path(Path)
    case type(StaticTypeValue)
    case capability(Capability)

    public var type: ValueType {
        switch self {
        case .void: return .void
        case .optional: return .optional
        case .bool: return .bool
        case .string: return .string
        case .address: return .address
        case .int: return .int
        case .uint: return .uint
        case .int8: return .int8
        case .uint8: return .uint8
        case .int16: return .int16
        case .uint16: return .uint16
        case .int32: return .int32
        case .uint32: return .uint32
        case .int64: return .int64
        case .uint64: return .uint64
        case .int128: return .int128
        case .uint128: return .uint128
        case .int256: return .int256
        case .uint256: return .uint256
        case .word8: return .word8
        case .word16: return .word16
        case .word32: return .word32
        case .word64: return .word64
        case .fix64: return .fix64
        case .ufix64: return .ufix64
        case .array: return .array
        case .dictionary: return .dictionary
        case .struct: return .struct
        case .resource: return .resource
        case .event: return .event
        case .contract: return .contract
        case .enum: return .enum
        case .path: return .path
        case .type: return .type
        case .capability: return .capability
        }
    }
}

// MARK: - Codable

extension Value: Codable {

    enum CodingKeys: CodingKey {
        case type
        case value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        switch self {
        case .void:
            break
        case let .optional(value):
            try container.encode(value, forKey: .value)
        case let .bool(bool):
            try container.encode(bool, forKey: .value)
        case let .string(string):
            try container.encode(string, forKey: .value)
        case let .address(address):
            try container.encode(address, forKey: .value)
        case let .int(int):
            try container.encode(String(int), forKey: .value)
        case let .uint(uint):
            try container.encode(String(uint), forKey: .value)
        case let .int8(int8):
            try container.encode(String(int8), forKey: .value)
        case let .uint8(uint8):
            try container.encode(String(uint8), forKey: .value)
        case let .int16(int16):
            try container.encode(String(int16), forKey: .value)
        case let .uint16(uint16):
            try container.encode(String(uint16), forKey: .value)
        case let .int32(int32):
            try container.encode(String(int32), forKey: .value)
        case let .uint32(uint32):
            try container.encode(String(uint32), forKey: .value)
        case let .int64(int64):
            try container.encode(String(int64), forKey: .value)
        case let .uint64(uint64):
            try container.encode(String(uint64), forKey: .value)
        case let .int128(int128):
            try container.encode(int128.description, forKey: .value)
        case let .uint128(uint128):
            try container.encode(uint128.description, forKey: .value)
        case let .int256(int256):
            try container.encode(int256.description, forKey: .value)
        case let .uint256(uint256):
            try container.encode(uint256.description, forKey: .value)
        case let .word8(word8):
            try container.encode(String(word8), forKey: .value)
        case let .word16(word16):
            try container.encode(String(word16), forKey: .value)
        case let .word32(word32):
            try container.encode(String(word32), forKey: .value)
        case let .word64(word64):
            try container.encode(String(word64), forKey: .value)
        case let .fix64(fix64):
            try container.encode(fix64.description.addingZeroDecimalIfNeeded, forKey: .value)
        case let .ufix64(ufix64):
            try container.encode(ufix64.description.addingZeroDecimalIfNeeded, forKey: .value)
        case let .array(array):
            try container.encode(array, forKey: .value)
        case let .dictionary(dictionary):
            try container.encode(dictionary, forKey: .value)
        case let .struct(`struct`):
            try container.encode(`struct`, forKey: .value)
        case let .resource(resource):
            try container.encode(resource, forKey: .value)
        case let .event(event):
            try container.encode(event, forKey: .value)
        case let .contract(contract):
            try container.encode(contract, forKey: .value)
        case let .enum(`enum`):
            try container.encode(`enum`, forKey: .value)
        case let .path(path):
            try container.encode(path, forKey: .value)
        case let .type(type):
            try container.encode(type, forKey: .value)
        case let .capability(capability):
            try container.encode(capability, forKey: .value)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(ValueType.self, forKey: .type)
        switch type {
        case .void:
            self = .void
        case .optional:
            self = .optional(try container.decodeIfPresent(Value.self, forKey: .value))
        case .bool:
            self = .bool(try container.decode(Bool.self, forKey: .value))
        case .string:
            self = .string(try container.decode(String.self, forKey: .value))
        case .address:
            self = .address(try container.decode(Address.self, forKey: .value))
        case .int:
            self = .int(try container.decodeBigIntFromString(forKey: .value))
        case .uint:
            self = .uint(try container.decodeBigUIntFromString(forKey: .value))
        case .int8:
            self = .int8(try container.decodeStringInteger(Int8.self, forKey: .value))
        case .uint8:
            self = .uint8(try container.decodeStringInteger(UInt8.self, forKey: .value))
        case .int16:
            self = .int16(try container.decodeStringInteger(Int16.self, forKey: .value))
        case .uint16:
            self = .uint16(try container.decodeStringInteger(UInt16.self, forKey: .value))
        case .int32:
            self = .int32(try container.decodeStringInteger(Int32.self, forKey: .value))
        case .uint32:
            self = .uint32(try container.decodeStringInteger(UInt32.self, forKey: .value))
        case .int64:
            self = .int64(try container.decodeStringInteger(Int64.self, forKey: .value))
        case .uint64:
            self = .uint64(try container.decodeStringInteger(UInt64.self, forKey: .value))
        case .int128:
            self = .int128(try container.decodeBigIntFromString(forKey: .value))
        case .uint128:
            self = .uint128(try container.decodeBigUIntFromString(forKey: .value))
        case .int256:
            self = .int256(try container.decodeBigIntFromString(forKey: .value))
        case .uint256:
            self = .uint256(try container.decodeBigUIntFromString(forKey: .value))
        case .word8:
            self = .word8(try container.decodeStringInteger(UInt8.self, forKey: .value))
        case .word16:
            self = .word16(try container.decodeStringInteger(UInt16.self, forKey: .value))
        case .word32:
            self = .word32(try container.decodeStringInteger(UInt32.self, forKey: .value))
        case .word64:
            self = .word64(try container.decodeStringInteger(UInt64.self, forKey: .value))
        case .fix64:
            self = .fix64(try container.decodeDecimalFromString(forKey: .value))
        case .ufix64:
            self = .ufix64(try container.decodeDecimalFromString(forKey: .value))
        case .array:
            self = .array(try container.decode([Value].self, forKey: .value))
        case .dictionary:
            self = .dictionary(try container.decode([Dictionary].self, forKey: .value))
        case .struct:
            self = .`struct`(try container.decode(CompositeStruct.self, forKey: .value))
        case .resource:
            self = .resource(try container.decode(CompositeResource.self, forKey: .value))
        case .event:
            self = .event(try container.decode(CompositeEvent.self, forKey: .value))
        case .contract:
            self = .contract(try container.decode(CompositeContract.self, forKey: .value))
        case .enum:
            self = .enum(try container.decode(CompositeEnum.self, forKey: .value))
        case .path:
            self = .path(try container.decode(Path.self, forKey: .value))
        case .type:
            self = .type(try container.decode(StaticTypeValue.self, forKey: .value))
        case .capability:
            self = .capability(try container.decode(Capability.self, forKey: .value))
        }
    }
}

// MARK: - To Swift Value

extension Value {

    public enum ValueDecodingError: Swift.Error {
        case mismatchType
        case invalidDictionaryKey
        case inconsistentDictionaryKeyType
    }

    private struct CompositeEnumWrapper<T: Decodable>: Decodable {
        let rawValue: T
    }

    public func toSwiftValue<T: Decodable>(decodableType: T.Type = T.self) throws -> T {
        if let value = try toSwiftValue(decodableType: Optional<T>.self) {
            return value
        } else {
            throw ValueDecodingError.mismatchType
        }
    }

    public func toSwiftValue<T: Decodable>(decodableType: Optional<T>.Type = Optional<T>.self) throws -> T? {
        guard let rawValue = try toSwiftRawValue() else {
            return nil
        }

        if let value = rawValue as? T {
            return value
        }

        guard JSONSerialization.isValidJSONObject(rawValue) else {
            throw ValueDecodingError.mismatchType
        }

        let data = try JSONSerialization.data(
            withJSONObject: rawValue,
            options: [.fragmentsAllowed])

        switch self {
        case .enum:
            return try JSONDecoder().decode(CompositeEnumWrapper<T>.self, from: data).rawValue
        default:
            return try JSONDecoder().decode(T.self, from: data)
        }
    }

    private func toSwiftRawValue() throws -> Any? {
        switch self {
        case .void:
            return nil
        case let .optional(value):
            return try value?.toSwiftRawValue()
        case let .bool(bool):
            return bool
        case let .string(string):
            return string
        case let .address(address):
            return address
        case let .int(bigInt):
            return bigInt
        case let .uint(bigUInt):
            return bigUInt
        case let .int8(int8):
            return int8
        case let .uint8(uint8):
            return uint8
        case let .int16(int16):
            return int16
        case let .uint16(uint16):
            return uint16
        case let .int32(int32):
            return int32
        case let .uint32(uint32):
            return uint32
        case let .int64(int64):
            return int64
        case let .uint64(uint64):
            return uint64
        case let .int128(bigInt):
            return bigInt
        case let .uint128(bigUInt):
            return bigUInt
        case let .int256(bigInt):
            return bigInt
        case let .uint256(bigUInt):
            return bigUInt
        case let .word8(uint8):
            return uint8
        case let .word16(uint16):
            return uint16
        case let .word32(uint32):
            return uint32
        case let .word64(uint64):
            return uint64
        case let .fix64(decimal):
            return decimal
        case let .ufix64(decimal):
            return decimal
        case let .array(array):
            return try array.map { try $0.toSwiftRawValue() }
        case let .dictionary(dictionary):
            guard let firstElement = dictionary.first else {
                return [:]
            }
            switch firstElement.key.type {
            case .void:
                throw ValueDecodingError.invalidDictionaryKey
            case .optional:
                throw ValueDecodingError.invalidDictionaryKey
            case .bool:
                return try makeSwiftDictionary(dictionary, type: Bool.self)
            case .string:
                return try makeSwiftDictionary(dictionary, type: String.self)
            case .address:
                return try makeSwiftDictionary(dictionary, type: Address.self)
            case .int:
                return try makeSwiftDictionary(dictionary, type: BigInt.self)
            case .uint:
                return try makeSwiftDictionary(dictionary, type: BigUInt.self)
            case .int8:
                return try makeSwiftDictionary(dictionary, type: Int8.self)
            case .uint8:
                return try makeSwiftDictionary(dictionary, type: UInt8.self)
            case .int16:
                return try makeSwiftDictionary(dictionary, type: Int16.self)
            case .uint16:
                return try makeSwiftDictionary(dictionary, type: UInt16.self)
            case .int32:
                return try makeSwiftDictionary(dictionary, type: Int32.self)
            case .uint32:
                return try makeSwiftDictionary(dictionary, type: UInt32.self)
            case .int64:
                return try makeSwiftDictionary(dictionary, type: Int64.self)
            case .uint64:
                return try makeSwiftDictionary(dictionary, type: UInt64.self)
            case .int128:
                return try makeSwiftDictionary(dictionary, type: BigInt.self)
            case .uint128:
                return try makeSwiftDictionary(dictionary, type: BigUInt.self)
            case .int256:
                return try makeSwiftDictionary(dictionary, type: BigInt.self)
            case .uint256:
                return try makeSwiftDictionary(dictionary, type: BigUInt.self)
            case .word8:
                return try makeSwiftDictionary(dictionary, type: Int8.self)
            case .word16:
                return try makeSwiftDictionary(dictionary, type: Int16.self)
            case .word32:
                return try makeSwiftDictionary(dictionary, type: Int32.self)
            case .word64:
                return try makeSwiftDictionary(dictionary, type: Int64.self)
            case .fix64:
                return try makeSwiftDictionary(dictionary, type: Decimal.self)
            case .ufix64:
                return try makeSwiftDictionary(dictionary, type: Decimal.self)
            case .array,
                 .dictionary,
                 .struct,
                 .resource,
                 .event,
                 .contract,
                 .enum,
                 .path,
                 .type,
                 .capability:
                throw ValueDecodingError.invalidDictionaryKey
            }
        case let .struct(compositeStruct):
            return try convertCompositeToDictionary(compositeStruct)
        case let .resource(compositeResource):
            return try convertCompositeToDictionary(compositeResource)
        case let .event(compositeEvent):
            return try convertCompositeToDictionary(compositeEvent)
        case let .contract(compositeContract):
            return try convertCompositeToDictionary(compositeContract)
        case let .enum(compositeEnum):
            return try convertCompositeToDictionary(compositeEnum)
        case let .path(path):
            return path
        case let .type(staticTypeValue):
            return staticTypeValue.staticType
        case let .capability(capability):
            return capability
        }
    }

    private func makeSwiftDictionary<KeyType: Hashable>(
        _ dictionary: [Cadence.Dictionary],
        type: KeyType.Type = KeyType.self
    ) throws -> [KeyType: Any] {
        var result: [KeyType: Any] = [:]
        try dictionary.forEach {
            guard let key = try $0.key.toSwiftRawValue() as? KeyType else {
                throw ValueDecodingError.inconsistentDictionaryKeyType
            }
            let value = try $0.value.toSwiftRawValue()
            result[key] = value
        }
        return result
    }

    private func convertCompositeToDictionary(_ composite: Composite) throws -> [String: Any?] {
        var result: [String: Any] = [:]
        try composite.fields.forEach {
            let value = try $0.value.toSwiftRawValue()
            if let bigInt = value as? BigInt {
                result[$0.name] = bigInt.description
            } else if let bigUInt = value as? BigUInt {
                result[$0.name] = bigUInt.description
            } else if let encodable = value as? Encodable {
                let value = try encodable.encoded(with: JSONEncoder())
                result[$0.name] = try JSONSerialization.jsonObject(
                    with: value,
                    options: [.fragmentsAllowed])
            } else {
                result[$0.name] = value
            }
        }
        return result
    }

}

private extension Encodable {

    func encoded<Encoder: TopLevelEncoder>(with encoder: Encoder) throws -> Data where Encoder.Output == Data {
        try encoder.encode(self)
    }
}

// MARK: - Static Function

extension Value {

    public static func decode(data: Data) throws -> Self {
        let decoder = JSONDecoder()
        decoder.userInfo[.decodingResults] = FTypeDecodingResults()
        return try decoder.decode(Self.self, from: data)
    }
}

// MARK: - CustomStringConvertible

extension Value: CustomStringConvertible {

    public var description: String {
        switch self {
        case .void:
            return Format.void.description
        case let .optional(value):
            if let value = value {
                return value.description
            } else {
                return Format.nil.description
            }
        case let .bool(bool):
            return Format.bool(bool).description
        case let .string(string):
            return Format.string(string).description
        case let .address(address):
            return Format.address(address).description
        case let .int(bigInt):
            return Format.bigInt(bigInt).description
        case let .uint(bigUInt):
            return Format.bigUInt(bigUInt).description
        case let .int8(int8):
            return Format.int8(int8).description
        case let .uint8(uint8):
            return Format.uint8(uint8).description
        case let .int16(int16):
            return Format.int16(int16).description
        case let .uint16(uint16):
            return Format.uint16(uint16).description
        case let .int32(int32):
            return Format.int32(int32).description
        case let .uint32(uint32):
            return Format.uint32(uint32).description
        case let .int64(int64):
            return Format.int64(int64).description
        case let .uint64(uint64):
            return Format.uint64(uint64).description
        case let .int128(bigInt):
            return Format.bigInt(bigInt).description
        case let .uint128(bigUInt):
            return Format.bigUInt(bigUInt).description
        case let .int256(bigInt):
            return Format.bigInt(bigInt).description
        case let .uint256(bigUInt):
            return Format.bigUInt(bigUInt).description
        case let .word8(uint8):
            return Format.uint8(uint8).description
        case let .word16(uint16):
            return Format.uint16(uint16).description
        case let .word32(uint32):
            return Format.uint32(uint32).description
        case let .word64(uint64):
            return Format.uint64(uint64).description
        case let .fix64(decimal):
            return Format.decimal(decimal).description
        case let .ufix64(decimal):
            return Format.decimal(decimal).description
        case let .array(array):
            return Format.array(array.map { $0.description }).description
        case let .dictionary(array):
            let pairs = array.map { (key: $0.key.description, value: $0.value.description) }
            return Format.dictionary(pairs).description
        case let .struct(compositeStruct):
            let pairs = compositeStruct.fields.map { (name: $0.name, value: $0.value.description) }
            return Format.composite(
                typeId: compositeStruct.id,
                fields: pairs
            ).description
        case let .resource(compositeResource):
            let pairs = compositeResource.fields.map { (name: $0.name, value: $0.value.description) }
            return Format.composite(
                typeId: compositeResource.id,
                fields: pairs
            ).description
        case let .event(compositeEvent):
            let pairs = compositeEvent.fields.map { (name: $0.name, value: $0.value.description) }
            return Format.composite(
                typeId: compositeEvent.id,
                fields: pairs
            ).description
        case let .contract(compositeContract):
            let pairs = compositeContract.fields.map { (name: $0.name, value: $0.value.description) }
            return Format.composite(
                typeId: compositeContract.id,
                fields: pairs
            ).description
        case let .enum(compositeEnum):
            let pairs = compositeEnum.fields.map { (name: $0.name, value: $0.value.description) }
            return Format.composite(
                typeId: compositeEnum.id,
                fields: pairs
            ).description
        case let .path(path):
            return Format.path(
                domain: path.domain.rawValue,
                identifier: path.identifier
            ).description
        case let .type(staticTypeValue):
            return Format.type(staticTypeValue.staticType).description
        case let .capability(capability):
            return Format.capability(
                borrowType: capability.borrowType,
                address: capability.address,
                path: capability.path
            ).description
        }
    }
}

// MARK: - String

private extension String {

    var addingZeroDecimalIfNeeded: String {
        var result = description
        if result.contains(".") == false {
            result += ".0"
        }
        return result
    }
}
