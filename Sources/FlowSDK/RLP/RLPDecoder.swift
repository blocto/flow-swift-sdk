//
//  RLPDecoder.swift
//
//  Created by Scott on 2022/8/6.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation
import BigInt

final public class RLPDecoder {

    public init() { }

    public func decodeRLPData(_ data: Data) throws -> RLPItem {
        try decodeRLPData(data, isList: false)
    }

    private func decodeRLPData(_ data: Data, isList: Bool) throws -> RLPItem {
        if data.count == 0 {
            if isList {
                return .list([])
            } else {
                return .empty
            }
        }

        var finalItems = [RLPItem]()
        var currentData = Data(data)
        while currentData.count != 0 {
            let (offset, dataLength, type) = try decodeLength(currentData)
            switch type {
            case .empty:
                break
            case .data:
                let slice = try slice(
                    data: currentData,
                    offset: offset,
                    length: dataLength)
                let data = Data(slice)
                finalItems.append(.data(data))
            case .list:
                let slice = try slice(
                    data: currentData,
                    offset: offset,
                    length: dataLength)
                let list = try decodeRLPData(Data(slice), isList: true)
                finalItems.append(list)
            }
            currentData = sliceRest(
                data: currentData,
                start: offset + dataLength)
        }
        if isList {
            return RLPItem.list(finalItems)
        } else {
            guard finalItems.count == 1 else {
                throw RLPDecodingError.invalidFormat
            }
            return finalItems[0]
        }
    }

    private func decodeLength(_ input: Data) throws -> (offset: BigUInt, length: BigUInt, type: RLPItemType) {
        let length = BigUInt(input.count)
        if (length == BigUInt(0)) {
            return (0, 0, .empty)
        }
        let prefixByte = input[0]
        if prefixByte <= 0x7f {
            return (0, 1, .data)
        } else if prefixByte <= 0xb7 && length > BigUInt(prefixByte - 0x80) {
            let dataLength = BigUInt(prefixByte - 0x80)
            return (1, dataLength, .data)
        } else if try prefixByte <= 0xbf && length > BigUInt(prefixByte - 0xb7) && length > BigUInt(prefixByte - 0xb7) + toBigUInt(slice(data: input, offset: BigUInt(1), length: BigUInt(prefixByte - 0xb7))) {
            let lengthOfLength = BigUInt(prefixByte - 0xb7)
            let dataLength = try toBigUInt(slice(data: input, offset: BigUInt(1), length: BigUInt(prefixByte - 0xb7)))
            return (1 + lengthOfLength, dataLength, .data)
        } else if prefixByte <= 0xf7 && length > BigUInt(prefixByte - 0xc0) {
            let listLen = BigUInt(prefixByte - 0xc0)
            return (1, listLen, .list)
        } else if try prefixByte <= 0xff && length > BigUInt(prefixByte - 0xf7) && length > BigUInt(prefixByte - 0xf7) + toBigUInt(slice(data: input, offset: BigUInt(1), length: BigUInt(prefixByte - 0xf7))) {
            let lengthOfListLength = BigUInt(prefixByte - 0xf7)
            let listLength = try toBigUInt(slice(data: input, offset: BigUInt(1), length: BigUInt(prefixByte - 0xf7)))
            return (1 + lengthOfListLength, listLength, .list)
        } else {
            throw RLPDecodingError.invalidFormat
        }
    }

    private func slice(data: Data, offset: BigUInt, length: BigUInt) throws -> Data {
        if BigUInt(data.count) < offset + length {
            throw RLPDecodingError.invalidFormat
        }
        let slice = data[UInt64(offset) ..< UInt64(offset + length)]
        return Data(slice)
    }

    private func sliceRest(data: Data, start: BigUInt) -> Data {
        if BigUInt(data.count) < start {
            return Data()
        } else {
            let slice = data[UInt64(start) ..< UInt64(data.count)]
            return Data(slice)
        }
    }

    private func toBigUInt(_ data: Data) throws -> BigUInt {
        if data.count == 0 {
            throw RLPDecodingError.invalidFormat
        } else if data.count == 1 {
            return BigUInt.init(data)
        } else {
            let slice = data[0 ..< data.count - 1]
            return try BigUInt(data[data.count-1]) + toBigUInt(slice)*256
        }
    }

}

private enum RLPItemType {
    case empty
    case data
    case list
}
