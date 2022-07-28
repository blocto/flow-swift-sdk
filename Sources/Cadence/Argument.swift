//
//  Argument.swift
//
//  Created by Scott on 2022/7/27.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation
import BigInt

public struct Argument: Equatable {

    public let type: ValueType

    public let value: Value

    public init(_ value: Value) {
        self.type = value.type
        self.value = value
    }
}

extension Argument: Codable {

    enum CodingKeys: CodingKey {
        case type
        case value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(value, forKey: .value)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(ValueType.self, forKey: .type)
        switch type {
        case .void:
            self.value = .void
        case .optional:
            self.value = .optional(try container.decodeIfPresent(Argument.self, forKey: .value))
        case .bool:
            self.value = .bool(try container.decode(Bool.self, forKey: .value))
        case .string:
            self.value = .string(try container.decode(String.self, forKey: .value))
        case .address:
            self.value = .address(try container.decode(Address.self, forKey: .value))
        case .int:
            self.value = .int(try container.decodeBigIntFromString(forKey: .value))
        case .uint:
            self.value = .uint(try container.decodeBigUIntFromString(forKey: .value))
        case .int8:
            self.value = .int8(try container.decodeStringInteger(Int8.self, forKey: .value))
        case .uint8:
            self.value = .uint8(try container.decodeStringInteger(UInt8.self, forKey: .value))
        case .int16:
            self.value = .int16(try container.decodeStringInteger(Int16.self, forKey: .value))
        case .uint16:
            self.value = .uint16(try container.decodeStringInteger(UInt16.self, forKey: .value))
        case .int32:
            self.value = .int32(try container.decodeStringInteger(Int32.self, forKey: .value))
        case .uint32:
            self.value = .uint32(try container.decodeStringInteger(UInt32.self, forKey: .value))
        case .int64:
            self.value = .int64(try container.decodeStringInteger(Int64.self, forKey: .value))
        case .uint64:
            self.value = .uint64(try container.decodeStringInteger(UInt64.self, forKey: .value))
        case .int128:
            self.value = .int128(try container.decodeBigIntFromString(forKey: .value))
        case .uint128:
            self.value = .uint128(try container.decodeBigUIntFromString(forKey: .value))
        case .int256:
            self.value = .int256(try container.decodeBigIntFromString(forKey: .value))
        case .uint256:
            self.value = .uint256(try container.decodeBigUIntFromString(forKey: .value))
        case .word8:
            self.value = .word8(try container.decodeStringInteger(UInt8.self, forKey: .value))
        case .word16:
            self.value = .word16(try container.decodeStringInteger(UInt16.self, forKey: .value))
        case .word32:
            self.value = .word32(try container.decodeStringInteger(UInt32.self, forKey: .value))
        case .word64:
            self.value = .word64(try container.decodeStringInteger(UInt64.self, forKey: .value))
        case .fix64:
            self.value = .fix64(try container.decodeDecimalFromString(forKey: .value))
        case .ufix64:
            self.value = .ufix64(try container.decodeDecimalFromString(forKey: .value))
        case .array:
            self.value = .array(try container.decode([Argument].self, forKey: .value))
        case .dictionary:
            self.value = .dictionary(try container.decode([Dictionary].self, forKey: .value))
        case .struct:
            self.value = .`struct`(try container.decode(CompositeStruct.self, forKey: .value))
        case .resource:
            self.value = .resource(try container.decode(CompositeResource.self, forKey: .value))
        case .event:
            self.value = .event(try container.decode(CompositeEvent.self, forKey: .value))
        case .contract:
            self.value = .contract(try container.decode(CompositeContract.self, forKey: .value))
        case .enum:
            self.value = .enum(try container.decode(CompositeEnum.self, forKey: .value))
        case .path:
            self.value = .path(try container.decode(Path.self, forKey: .value))
        case .type:
            self.value = .type(try container.decode(StaticTypeValue.self, forKey: .value))
        case .capability:
            self.value = .capability(try container.decode(Capability.self, forKey: .value))
        }
    }
}

// MARK: - To Swift Value

extension Argument {

    public func toSwiftValue<T: Decodable>(decodableType: T.Type = T.self) throws -> T {
        try value.toSwiftValue(decodableType: decodableType)
    }

    public func toSwiftValue<T: Decodable>(decodableType: Optional<T>.Type = Optional<T>.self) throws -> T? {
        try value.toSwiftValue(decodableType: decodableType)
    }
}

// MARK: - Static Function

extension Argument {

    public static func decode(data: Data) throws -> Self {
        let decoder = JSONDecoder()
        decoder.userInfo[.decodingResults] = FTypeDecodingResults()
        return try decoder.decode(Self.self, from: data)
    }
}

// MARK: - Convenience

extension Argument {

    public static var void: Argument {
        Argument(.void)
    }

    public static func optional(_ value: Argument?) -> Argument {
        Argument(.optional(value))
    }

    public static func bool(_ value: Bool) -> Argument {
        Argument(.bool(value))
    }

    public static func string(_ value: String) -> Argument {
        Argument(.string(value))
    }

    public static func address(_ value: Address) -> Argument {
        Argument(.address(value))
    }

    public static func int(_ value: BigInt) -> Argument {
        Argument(.int(value))
    }

    public static func uint(_ value: BigUInt) -> Argument {
        Argument(.uint(value))
    }

    public static func int8(_ value: Int8) -> Argument {
        Argument(.int8(value))
    }

    public static func uint8(_ value: UInt8) -> Argument {
        Argument(.uint8(value))
    }

    public static func int16(_ value: Int16) -> Argument {
        Argument(.int16(value))
    }

    public static func uint16(_ value: UInt16) -> Argument {
        Argument(.uint16(value))
    }

    public static func int32(_ value: Int32) -> Argument {
        Argument(.int32(value))
    }

    public static func uint32(_ value: UInt32) -> Argument {
        Argument(.uint32(value))
    }

    public static func int64(_ value: Int64) -> Argument {
        Argument(.int64(value))
    }

    public static func uint64(_ value: UInt64) -> Argument {
        Argument(.uint64(value))
    }

    public static func int128(_ value: BigInt) -> Argument {
        Argument(.int128(value))
    }

    public static func uint128(_ value: BigUInt) -> Argument {
        Argument(.uint128(value))
    }

    public static func int256(_ value: BigInt) -> Argument {
        Argument(.int256(value))
    }

    public static func uint256(_ value: BigUInt) -> Argument {
        Argument(.uint256(value))
    }

    public static func word8(_ value: UInt8) -> Argument {
        Argument(.word8(value))
    }

    public static func word16(_ value: UInt16) -> Argument {
        Argument(.word16(value))
    }

    public static func word32(_ value: UInt32) -> Argument {
        Argument(.word32(value))
    }

    public static func word64(_ value: UInt64) -> Argument {
        Argument(.word64(value))
    }

    public static func fix64(_ value: Decimal) -> Argument {
        Argument(.fix64(value))
    }

    public static func ufix64(_ value: Decimal) -> Argument {
        Argument(.ufix64(value))
    }

    public static func array(_ value: [Argument]) -> Argument {
        Argument(.array(value))
    }

    public static func array(_ value: Argument...) -> Argument {
        Argument(.array(value))
    }

    public static func dictionary(_ value: [Dictionary]) -> Argument {
        Argument(.dictionary(value))
    }

    public static func dictionary(_ value: Dictionary...) -> Argument {
        Argument(.dictionary(value))
    }

    public static func `struct`(_ value: CompositeStruct) -> Argument {
        Argument(.struct(value))
    }

    public static func `struct`(id: String, fields: [Composite.Field]) -> Argument {
        Argument(.struct(.init(id: id, fields: fields)))
    }

    public static func resource(_ value: CompositeStruct) -> Argument {
        Argument(.resource(value))
    }

    public static func resource(id: String, fields: [Composite.Field]) -> Argument {
        Argument(.resource(.init(id: id, fields: fields)))
    }

    public static func event(_ value: CompositeStruct) -> Argument {
        Argument(.event(value))
    }

    public static func event(id: String, fields: [Composite.Field]) -> Argument {
        Argument(.event(.init(id: id, fields: fields)))
    }

    public static func contract(_ value: CompositeStruct) -> Argument {
        Argument(.contract(value))
    }

    public static func contract(id: String, fields: [Composite.Field]) -> Argument {
        Argument(.contract(.init(id: id, fields: fields)))
    }

    public static func `enum`(_ value: CompositeStruct) -> Argument {
        Argument(.enum(value))
    }

    public static func `enum`(id: String, fields: [Composite.Field]) -> Argument {
        Argument(.enum(.init(id: id, fields: fields)))
    }

    public static func path(_ value: Path) -> Argument {
        Argument(.path(value))
    }

    public static func path(domain: Path.Domain, identifier: String) -> Argument {
        Argument(.path(Path(domain: domain, identifier: identifier)))
    }

    public static func type(_ value: StaticTypeValue) -> Argument {
        Argument(.type(value))
    }

    public static func type(staticType: FType) -> Argument {
        Argument(.type(.init(staticType: staticType)))
    }

    public static func capability(_ value: Capability) -> Argument {
        Argument(.capability(value))
    }

    public static func capability(path: String, address: Address, borrowType: FType) -> Argument {
        Argument(.capability(Capability(path: path, address: address, borrowType: borrowType)))
    }

}
