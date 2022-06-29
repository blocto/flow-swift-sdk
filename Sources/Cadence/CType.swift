//
//  CType.swift
// 
//  Created by Scott on 2022/6/21.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

public enum CType: Equatable {
    case `any`
    case anyStruct
    case anyResource
    case type
    case void
    case never
    case bool
    case string
    case character
    case bytes
    case address
    case number
    case signedNumber
    case integer
    case signedInteger
    case fixedPoint
    case signedFixedPoint
    case int
    case int8
    case int16
    case int32
    case int64
    case int128
    case int256
    case uint
    case uint8
    case uint16
    case uint32
    case uint64
    case uint128
    case uint256
    case word8
    case word16
    case word32
    case word64
    case fix64
    case ufix64
    case path
    case capabilityPath
    case storagePath
    case publicPath
    case privatePath
    case authAccount
    case publicAccount
    case authAccountKeys
    case publicAccountKeys
    case authAccountContracts
    case publicAccountContracts
    case deployedContract
    case accountKey
    case block
    indirect case optional(CType)
    indirect case variableSizedArray(elementType: CType)
    indirect case constantSizedArray(elementType: CType, size: Int)
    indirect case dictionary(keyType: CType, elementType: CType)
    indirect case `struct`(CompositeType)
    indirect case resource(CompositeType)
    indirect case event(CompositeType)
    indirect case contract(CompositeType)
    indirect case structInterface(CompositeType)
    indirect case resourceInterface(CompositeType)
    indirect case contractInterface(CompositeType)
    indirect case function(FunctionType)
    indirect case reference(ReferenceType)
    indirect case restriction(RestrictionType)
    indirect case capability(borrowType: CType)
    indirect case `enum`(EnumType)

    public var kind: CTypeKind {
        switch self {
        case .any:
            return .any
        case .anyStruct:
            return .anyStruct
        case .anyResource:
            return .anyResource
        case .type:
            return .type
        case .void:
            return .void
        case .never:
            return .never
        case .bool:
            return .bool
        case .string:
            return .string
        case .character:
            return .character
        case .bytes:
            return .bytes
        case .address:
            return .address
        case .number:
            return .number
        case .signedNumber:
            return .signedNumber
        case .integer:
            return .integer
        case .signedInteger:
            return .signedInteger
        case .fixedPoint:
            return .fixedPoint
        case .signedFixedPoint:
            return .signedFixedPoint
        case .int:
            return .int
        case .int8:
            return .int8
        case .int16:
            return .int16
        case .int32:
            return .int32
        case .int64:
            return .int64
        case .int128:
            return .int128
        case .int256:
            return .int256
        case .uint:
            return .uint
        case .uint8:
            return .uint8
        case .uint16:
            return .uint16
        case .uint32:
            return .uint32
        case .uint64:
            return .uint64
        case .uint128:
            return .uint128
        case .uint256:
            return .uint256
        case .word8:
            return .word8
        case .word16:
            return .word16
        case .word32:
            return .word32
        case .word64:
            return .word64
        case .fix64:
            return .fix64
        case .ufix64:
            return .ufix64
        case .path:
            return .path
        case .capabilityPath:
            return .capabilityPath
        case .storagePath:
            return .storagePath
        case .publicPath:
            return .publicPath
        case .privatePath:
            return .privatePath
        case .authAccount:
            return .authAccount
        case .publicAccount:
            return .publicAccount
        case .authAccountKeys:
            return .authAccountKeys
        case .publicAccountKeys:
            return .publicAccountKeys
        case .authAccountContracts:
            return .authAccountContracts
        case .publicAccountContracts:
            return .publicAccountContracts
        case .deployedContract:
            return .deployedContract
        case .accountKey:
            return .accountKey
        case .block:
            return .block
        case .optional:
            return .optional
        case .variableSizedArray:
            return .variableSizedArray
        case .constantSizedArray:
            return .constantSizedArray
        case .dictionary:
            return .dictionary
        case .struct:
            return .struct
        case .resource:
            return .resource
        case .event:
            return .event
        case .contract:
            return .contract
        case .structInterface:
            return .structInterface
        case .resourceInterface:
            return .resourceInterface
        case .contractInterface:
            return .contractInterface
        case .function:
            return .function
        case .reference:
            return .reference
        case .restriction:
            return .restriction
        case .capability:
            return .capability
        case .enum:
            return .enum
        }
    }

    public var id: String {
        switch self {
        case .any, .anyStruct, .anyResource,
             .type, .void, .never,
             .bool, .string, .character, .bytes, .address,
             .number, .signedNumber, .integer, .signedInteger,
             .fixedPoint, .signedFixedPoint,
             .int, .int8, .int16, .int32, .int64, .int128, .int256,
             .uint, .uint8, .uint16, .uint32, .uint64, .uint128, .uint256,
             .word8, .word16, .word32, .word64,
             .fix64, .ufix64,
             .path, .capabilityPath, .storagePath, .publicPath, .privatePath,
             .authAccount, .publicAccount, .authAccountKeys, .publicAccountKeys,
             .authAccountContracts, .publicAccountContracts, .deployedContract,
             .accountKey, .block:
            return kind.rawValue
        case let .optional(type):
            return "\(type.kind.rawValue)?"
        case let .variableSizedArray(elementType):
            return "[\(elementType.kind.rawValue)]"
        case let .constantSizedArray(elementType, size):
            return "[\(elementType.kind.rawValue);\(size)]"
        case let .dictionary(keyType, elementType):
            return "{\(keyType.kind.rawValue):\(elementType.kind.rawValue)}"
        case let .struct(compositeType):
            return compositeType.typeId
        case let .resource(compositeType):
            return compositeType.typeId
        case let .event(compositeType):
            return compositeType.typeId
        case let .contract(compositeType):
            return compositeType.typeId
        case let .structInterface(compositeType):
            return compositeType.typeId
        case let .resourceInterface(compositeType):
            return compositeType.typeId
        case let .contractInterface(compositeType):
            return compositeType.typeId
        case let .function(functionType):
            return functionType.typeId
        case let .reference(referenceType):
            var id = "&\(referenceType.type.id)"
            if referenceType.authorized {
                id = "auth" + id
            }
            return id
        case let .restriction(restrictionType):
            return restrictionType.typeId
        case let .capability(borrowType):
            return "\(kind.rawValue)<\(borrowType.id)>"
        case let .enum(enumType):
            return enumType.typeId
        }
    }
}

// MARK: - Codable

extension CType: Codable {

    enum CodingKeys: CodingKey {
        case kind
        case type
    }

    enum ConstantSizedArrayCodingKeys: CodingKey {
        case type
        case size
    }

    enum DictionaryCodingKeys: CodingKey {
        case key
        case value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(kind, forKey: .kind)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind = try container.decode(CTypeKind.self, forKey: .kind)
        switch kind {
        case .any:
            self = .any
        case .anyStruct:
            self = .anyStruct
        case .anyResource:
            self = .anyResource
        case .type:
            self = .type
        case .void:
            self = .void
        case .never:
            self = .never
        case .bool:
            self = .bool
        case .string:
            self = .string
        case .character:
            self = .character
        case .bytes:
            self = .bytes
        case .address:
            self = .address
        case .number:
            self = .number
        case .signedNumber:
            self = .signedNumber
        case .integer:
            self = .integer
        case .signedInteger:
            self = .signedInteger
        case .fixedPoint:
            self = .fixedPoint
        case .signedFixedPoint:
            self = .signedFixedPoint
        case .int:
            self = .int
        case .int8:
            self = .int8
        case .int16:
            self = .int16
        case .int32:
            self = .int32
        case .int64:
            self = .int64
        case .int128:
            self = .int128
        case .int256:
            self = .int256
        case .uint:
            self = .uint
        case .uint8:
            self = .uint8
        case .uint16:
            self = .uint16
        case .uint32:
            self = .uint32
        case .uint64:
            self = .uint64
        case .uint128:
            self = .uint128
        case .uint256:
            self = .uint256
        case .word8:
            self = .word8
        case .word16:
            self = .word16
        case .word32:
            self = .word32
        case .word64:
            self = .word64
        case .fix64:
            self = .fix64
        case .ufix64:
            self = .ufix64
        case .path:
            self = .path
        case .capabilityPath:
            self = .capabilityPath
        case .storagePath:
            self = .storagePath
        case .publicPath:
            self = .publicPath
        case .privatePath:
            self = .privatePath
        case .authAccount:
            self = .authAccount
        case .publicAccount:
            self = .publicAccount
        case .authAccountKeys:
            self = .authAccountKeys
        case .publicAccountKeys:
            self = .publicAccountKeys
        case .authAccountContracts:
            self = .authAccountContracts
        case .publicAccountContracts:
            self = .publicAccountContracts
        case .deployedContract:
            self = .deployedContract
        case .accountKey:
            self = .accountKey
        case .block:
            self = .block
        case .optional:
            let type = try container.decodeCType(userInfo: decoder.userInfo, forKey: .type)
            self = .optional(type)
        case .variableSizedArray:
            let element = try container.decodeCType(userInfo: decoder.userInfo, forKey: .type)
            self = .variableSizedArray(elementType: element)
        case .constantSizedArray:
            let container = try decoder.container(keyedBy: ConstantSizedArrayCodingKeys.self)
            let element = try container.decodeCType(userInfo: decoder.userInfo, forKey: .type)
            let size = try container.decode(Int.self, forKey: .size)
            self = .constantSizedArray(elementType: element, size: size)
        case .dictionary:
            let container = try decoder.container(keyedBy: DictionaryCodingKeys.self)
            let key = try container.decodeCType(userInfo: decoder.userInfo, forKey: .key)
            let element = try container.decodeCType(userInfo: decoder.userInfo, forKey: .value)
            self = .dictionary(keyType: key, elementType: element)
        case .struct:
            let compositeType = try CompositeType(from: decoder)
            self = .struct(compositeType)
            decoder.addTypeToDecodingResultsIfPossible(type: self, typeId: compositeType.typeId)
            try compositeType.decodeFieldTypes(from: decoder)
        case .resource:
            let compositeType = try CompositeType(from: decoder)
            self = .resource(compositeType)
            decoder.addTypeToDecodingResultsIfPossible(type: self, typeId: compositeType.typeId)
            try compositeType.decodeFieldTypes(from: decoder)
        case .event:
            let compositeType = try CompositeType(from: decoder)
            self = .event(compositeType)
            decoder.addTypeToDecodingResultsIfPossible(type: self, typeId: compositeType.typeId)
            try compositeType.decodeFieldTypes(from: decoder)
        case .contract:
            let compositeType = try CompositeType(from: decoder)
            self = .contract(compositeType)
            decoder.addTypeToDecodingResultsIfPossible(type: self, typeId: compositeType.typeId)
            try compositeType.decodeFieldTypes(from: decoder)
        case .structInterface:
            let compositeType = try CompositeType(from: decoder)
            self = .structInterface(compositeType)
            decoder.addTypeToDecodingResultsIfPossible(type: self, typeId: compositeType.typeId)
            try compositeType.decodeFieldTypes(from: decoder)
        case .resourceInterface:
            let compositeType = try CompositeType(from: decoder)
            self = .resourceInterface(compositeType)
            decoder.addTypeToDecodingResultsIfPossible(type: self, typeId: compositeType.typeId)
            try compositeType.decodeFieldTypes(from: decoder)
        case .contractInterface:
            let compositeType = try CompositeType(from: decoder)
            self = .contractInterface(compositeType)
            decoder.addTypeToDecodingResultsIfPossible(type: self, typeId: compositeType.typeId)
            try compositeType.decodeFieldTypes(from: decoder)
        case .function:
            let functionType = try FunctionType(from: decoder)
            self = .function(functionType)
            decoder.addTypeToDecodingResultsIfPossible(type: self, typeId: functionType.typeId)
            try functionType.decodePossibleRepeatedProperties(from: decoder)
        case .reference:
            self = .reference(try ReferenceType(from: decoder))
        case .restriction:
            let restrictionType = try RestrictionType(from: decoder)
            self = .restriction(restrictionType)
            decoder.addTypeToDecodingResultsIfPossible(type: self, typeId: restrictionType.typeId)
            try restrictionType.decodePossibleRepeatedProperties(from: decoder)
        case .capability:
            let type = try container.decodeCType(userInfo: decoder.userInfo, forKey: .type)
            self = .capability(borrowType: type)
        case .enum:
            let enumType = try EnumType(from: decoder)
            self = .enum(enumType)
            decoder.addTypeToDecodingResultsIfPossible(type: self, typeId: enumType.typeId)
            try enumType.decodePossibleRepeatedProperties(from: decoder)
        }
    }

}

// MARK: - Decoder

private extension Decoder {

    func addTypeToDecodingResultsIfPossible(type: CType, typeId: String) {
        if let results = userInfo[.decodingResults] as? CTypeDecodingResults {
            results.value = [typeId: type]
        }
    }
}
