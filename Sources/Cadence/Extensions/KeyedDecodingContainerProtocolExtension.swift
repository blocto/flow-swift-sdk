//
//  KeyedDecodingContainerProtocolExtension.swift
// 
//  Created by Scott on 2022/5/20.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation
import BigInt

// MARK: - BigInt, BigUInt
extension KeyedDecodingContainerProtocol {

    func decodeBigIntFromString(forKey key: Self.Key) throws -> BigInt {
        let string = try decode(String.self, forKey: key)
        guard let bigInt = BigInt(string) else {
            throw DecodingError.dataCorruptedError(
                forKey: key,
                in: self,
                debugDescription: "Expected BigInt string")
        }
        return bigInt
    }

    func decodeBigUIntFromString(forKey key: Self.Key) throws -> BigUInt {
        let string = try decode(String.self, forKey: key)
        guard let bigUInt = BigUInt(string) else {
            throw DecodingError.dataCorruptedError(
                forKey: key,
                in: self,
                debugDescription: "Expected BigInt string")
        }
        return bigUInt
    }

}

// MARK: - Decimal
extension KeyedDecodingContainerProtocol {

    func decodeDecimalFromString(forKey key: Self.Key) throws -> Decimal {
        let string = try decode(String.self, forKey: key)
        guard let decimal = Decimal(string: string) else {
            throw DecodingError.dataCorruptedError(
                forKey: key,
                in: self,
                debugDescription: "Expected Decimal string")
        }
        return decimal
    }
}

// MARK: - String Integer

extension KeyedDecodingContainerProtocol {

    func decodeStringInteger<IntegerType: FixedWidthInteger>(
        _ type: IntegerType.Type,
        forKey key: Self.Key
    ) throws -> IntegerType {
        let text = try decode(String.self, forKey: key)
        guard let value = IntegerType(text) else {
            throw DecodingError.dataCorruptedError(
                forKey: key,
                in: self,
                debugDescription: "Expected \(IntegerType.self) string")
        }
        return value
    }
}

// MARK: StaticType

extension KeyedDecodingContainerProtocol {

    func decodeStaticType(
        userInfo: [CodingUserInfoKey: Any],
        forKey key: Self.Key
    ) throws -> StaticType {
        if let typeId = try? decode(String.self, forKey: key) {
            if let results = userInfo[.decodingResults] as? StaticTypeDecodingResults,
               let type = results.value[typeId] {
                return type
            } else {
                throw DecodingError.dataCorruptedError(
                    forKey: key,
                    in: self,
                    debugDescription: "TypeID(\(typeId)) Not found")
            }
        } else {
            let type = try decode(StaticType.self, forKey: key)
            return type
        }
    }

}

