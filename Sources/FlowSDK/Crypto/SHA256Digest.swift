//
//  SHA256Digest.swift
// 
//  Created by Scott on 2022/6/6.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation
import CryptoKit
import secp256k1Swift

public struct SHA256Digest: CryptoKit.Digest, secp256k1Swift.Digest {

    let bytes: (UInt64, UInt64, UInt64, UInt64)

    init?(data: Data) {
        self.init(bytes: [UInt8](data))
    }

    init?(bytes: [UInt8]) {
        let some = bytes.withUnsafeBytes { bufferPointer in
            return Self(bufferPointer: bufferPointer)
        }

        if some != nil {
            self = some!
        } else {
            return nil
        }
    }

    init?(bufferPointer: UnsafeRawBufferPointer) {
        guard bufferPointer.count == 32 else {
            return nil
        }

        var bytes = (UInt64(0), UInt64(0), UInt64(0), UInt64(0))
        withUnsafeMutableBytes(of: &bytes) { targetPtr in
            targetPtr.copyMemory(from: bufferPointer)
        }
        self.bytes = bytes
    }

    public static var byteCount: Int {
        return 32
    }

    public func withUnsafeBytes<R>(_ body: (UnsafeRawBufferPointer) throws -> R) rethrows -> R {
        return try Swift.withUnsafeBytes(of: bytes) {
            let boundsCheckedPtr = UnsafeRawBufferPointer(start: $0.baseAddress,
                                                          count: Self.byteCount)
            return try body(boundsCheckedPtr)
        }
    }

    // MARK: - CustomStringConvertible

    private func toArray() -> ArraySlice<UInt8> {
        var array = [UInt8]()
        array.appendByte(bytes.0)
        array.appendByte(bytes.1)
        array.appendByte(bytes.2)
        array.appendByte(bytes.3)
        return array.prefix(upTo: SHA256Digest.byteCount)
    }

    public var description: String {
        return "\("SHA256") digest: \(toArray())"
    }

    // MARK: - Equatable

    public static func == (lhs: SHA256Digest, rhs: SHA256Digest) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    // MARK: - Hashable

    public func hash(into hasher: inout Hasher) {
        withUnsafeBytes { hasher.combine(bytes: $0) }
    }

    // MARK: - Sequence

    public func makeIterator() -> Array<UInt8>.Iterator {
        withUnsafeBytes {
            Array($0).makeIterator()
        }
    }

}

extension MutableDataProtocol {

    mutating func appendByte(_ byte: UInt64) {
        withUnsafePointer(
            to: byte.littleEndian,
            { append(contentsOf: UnsafeRawBufferPointer(start: $0, count: 8)) })
    }
}
