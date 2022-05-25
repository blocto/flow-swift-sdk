//
//  CadenceType.swift
// 
//  Created by Scott on 2022/5/18.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

public enum `Type`: String, Equatable, Codable {
    case void = "Void"
    case optional = "Optional"
    case bool = "Bool"
    case string = "String"
    case address = "Address"
    case int = "Int"
    case uint = "UInt"
    case int8 = "Int8"
    case uint8 = "UInt8"
    case int16 = "Int16"
    case uint16 = "UInt16"
    case int32 = "Int32"
    case uint32 = "UInt32"
    case int64 = "Int64"
    case uint64 = "UInt64"
    case int128 = "Int128"
    case uint128 = "UInt128"
    case int256 = "Int256"
    case uint256 = "UInt256"
    case word8 = "Word8"
    case word16 = "Word16"
    case word32 = "Word32"
    case word64 = "Word64"
    case fix64 = "Fix64"
    case ufix64 = "UFix64"
    case array = "Array"
    case dictionary = "Dictionary"
    case `struct` = "Struct"
    case resource = "Resource"
    case event = "Event"
    case contract = "Contract"
    case `enum` = "Enum"
    case path = "Path"
    case type = "Type"
    case capability = "Capability"
}
