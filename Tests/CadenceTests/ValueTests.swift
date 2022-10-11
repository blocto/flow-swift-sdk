//
//  ValueTests.swift
//
//  Created by Scott on 2022/6/22.
//  Copyright © 2022 portto. All rights reserved.
//

import XCTest
import Cadence
import BigInt

final class ValueTests: XCTestCase {

    func testToSwiftValueVoid() throws {
        // Arrange
        let value: Cadence.Value = .void

        // Act
        let result: Int? = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, nil)
    }

    func testToSwiftValueOptionalNil() throws {
        // Arrange
        let value: Cadence.Value = .optional(nil)

        // Act
        let result: Int? = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, nil)
    }

    func testToSwiftValueOptionalSomePrimitive() throws {
        // Arrange
        let value: Cadence.Value = .optional(.int8(10))

        // Act
        let result: Int8? = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, 10)
    }

    func testToSwiftValueOptionalSomeBigInt() throws {
        // Arrange
        let value: Cadence.Value = .optional(.int(100))

        // Act
        let result: BigInt? = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, 100)
        XCTAssertThrowsError(try value.toSwiftValue(decodableType: Int.self))
    }

    func testToSwiftValueOptionalSomeDecodable() throws {
        // Arrange
        struct TestStruct: Codable, Equatable {
            let name: String
            let salary: String
        }
        let value: Cadence.Value = .optional(.struct(
            id: "id",
            fields: [
                .init(name: "name", value: .string("Scott")),
                .init(name: "salary", value: .fix64(0.01))
            ])
        )

        // Act
        let result: TestStruct? = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, TestStruct(name: "Scott", salary: "0.01"))
        XCTAssertThrowsError(try value.toSwiftValue(decodableType: Int.self))
    }

    func testToSwiftValueBool() throws {
        // Arrange
        let value: Cadence.Value = .bool(true)

        // Act
        let result: Bool = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, true)
    }

    func testToSwiftValueString() throws {
        // Arrange
        let value: Cadence.Value = .string("Scott")

        // Act
        let result: String = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, "Scott")
    }

    func testToSwiftValueAddress() throws {
        // Arrange
        let address = Address(hexString: "0xcb2d04fc89307107")
        let value: Cadence.Value = .address(address)

        // Act
        let result: Address = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, address)
    }

    func testToSwiftValueInt() throws {
        // Arrange
        let value: Cadence.Value = .int(5566)

        // Act
        let result: BigInt = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, BigInt(5566))
    }

    func testToSwiftValueUInt() throws {
        // Arrange
        let value: Cadence.Value = .uint(5566)

        // Act
        let result: BigUInt = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, BigUInt(5566))
    }

    func testToSwiftValueInt8() throws {
        // Arrange
        let value: Cadence.Value = .int8(-8)

        // Act
        let result: Int8 = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, -8)
    }

    func testToSwiftValueUInt8() throws {
        // Arrange
        let value: Cadence.Value = .uint8(8)

        // Act
        let result: UInt8 = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, 8)
    }

    func testToSwiftValueInt16() throws {
        // Arrange
        let value: Cadence.Value = .int16(-16)

        // Act
        let result: Int16 = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, -16)
    }

    func testToSwiftValueUInt16() throws {
        // Arrange
        let value: Cadence.Value = .uint16(16)

        // Act
        let result: UInt16 = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, 16)
    }

    func testToSwiftValueInt32() throws {
        // Arrange
        let value: Cadence.Value = .int32(-32)

        // Act
        let result: Int32 = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, -32)
    }

    func testToSwiftValueUInt32() throws {
        // Arrange
        let value: Cadence.Value = .uint32(32)

        // Act
        let result: UInt32 = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, 32)
    }

    func testToSwiftValueInt64() throws {
        // Arrange
        let value: Cadence.Value = .int64(-64)

        // Act
        let result: Int64 = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, -64)
    }

    func testToSwiftValueUInt64() throws {
        // Arrange
        let value: Cadence.Value = .uint64(64)

        // Act
        let result: UInt64 = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, 64)
    }

    func testToSwiftValueInt128() throws {
        // Arrange
        let value: Cadence.Value = .int128(-128)

        // Act
        let result: BigInt = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, BigInt(-128))
    }

    func testToSwiftValueUInt128() throws {
        // Arrange
        let value: Cadence.Value = .uint128(128)

        // Act
        let result: BigUInt = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, BigUInt(128))
    }

    func testToSwiftValueInt256() throws {
        // Arrange
        let value: Cadence.Value = .int256(-256)

        // Act
        let result: BigInt = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, BigInt(-256))
    }

    func testToSwiftValueUInt256() throws {
        // Arrange
        let value: Cadence.Value = .uint256(256)

        // Act
        let result: BigUInt = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, BigUInt(256))
    }

    func testToSwiftValueWord8() throws {
        // Arrange
        let value: Cadence.Value = .word8(8)

        // Act
        let result: UInt8 = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, 8)
    }

    func testToSwiftValueWord16() throws {
        // Arrange
        let value: Cadence.Value = .word16(16)

        // Act
        let result: UInt16 = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, 16)
    }

    func testToSwiftValueWord32() throws {
        // Arrange
        let value: Cadence.Value = .word32(32)

        // Act
        let result: UInt32 = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, 32)
    }

    func testToSwiftValueWord64() throws {
        // Arrange
        let value: Cadence.Value = .word64(64)

        // Act
        let result: UInt64 = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, 64)
    }

    func testToSwiftValueFix64() throws {
        // Arrange
        let value: Cadence.Value = .fix64(Decimal(string: "-123.45")!)

        // Act
        let result: Decimal = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, Decimal(string: "-123.45")!)
    }

    func testToSwiftValueUFix64() throws {
        // Arrange
        let value: Cadence.Value = .fix64(Decimal(string: "123.45")!)

        // Act
        let result: Decimal = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, Decimal(string: "123.45")!)
    }

    func testToSwiftValueArrayInt() throws {
        // Arrange
        let value: Cadence.Value = .array([
            .int(5),
            .int(6),
            .int(7),
            .int(8),
        ])

        // Act
        let result: [BigInt] = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, [5, 6, 7, 8])
    }

    func testToSwiftValueArrayDifferentType() throws {
        // Arrange
        let value: Cadence.Value = .array([
            .int(5),
            .int(6),
            .int(7),
            .string("QQ")
        ])

        // Assert
        XCTAssertThrowsError(try value.toSwiftValue(decodableType: [BigInt].self))
    }

    func testToSwiftValueDictionary() throws {
        // Arrange
        let value: Cadence.Value = .dictionary([
            .init(key: .string("apple"), value: .int(1)),
            .init(key: .string("orange"), value: .int(2))
        ])

        // Act
        let result: [String: BigInt] = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, ["apple": BigInt(1), "orange": BigInt(2)])
    }

    func testToSwiftValueStruct() throws {
        // Arrange
        struct TestStruct: Codable, Equatable {
            let name: String
        }
        let value: Cadence.Value = .struct(.init(
            id: "s.5a312c0cf513ac0b3464c980e7c61d9d7fedd8cde2fa64ad0c617344fb993bf4.Fruit",
            fields: [
                .init(name: "name", value: .string("Scott"))
            ]
        ))

        // Act
        let result: TestStruct = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, TestStruct(name: "Scott"))
    }

    func testToSwiftValueResourceWithBigInt() throws {
        // Arrange
        struct GreatNFT: Codable, Equatable {
            let power: BigInt

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let string = try container.decode(String.self, forKey: .power)
                self.power = BigInt(string) ?? 0
            }

            init(power: BigInt) {
                self.power = power
            }
        }
        let value: Cadence.Value = .resource(.init(
            id: "0x3.GreatContract.GreatNFT",
            fields: [
                .init(name: "power", value: .int(1))
            ]
        ))

        // Act
        let result: GreatNFT = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, GreatNFT(power: 1))
    }

    func testToSwiftValueResourceWithInt64() throws {
        // Arrange
        struct GreatNFT: Codable, Equatable {
            let power: Int64
        }
        let value: Cadence.Value = .resource(.init(
            id: "0x3.GreatContract.GreatNFT",
            fields: [
                .init(name: "power", value: .int64(1))
            ]
        ))

        // Act
        let result: GreatNFT = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, GreatNFT(power: 1))
    }

    func testToSwiftValueEvent() throws {
        // Arrange
        struct TokensWithdrawn: Codable, Equatable {
            let amount: String
            let from: Address?
        }
        let amount = Decimal(string: "0.00000169")!
        let address = Address(hexString: "0xebf4ae01d1284af8")
        let value: Cadence.Value = .event(.init(
            id: "A.7e60df042a9c0868.FlowToken.TokensWithdrawn",
            fields: [
                .init(
                    name: "amount",
                    value: .ufix64(amount)),
                .init(
                    name: "from",
                    value: .optional(.address(address)))
            ]
        ))

        // Act
        let result: TokensWithdrawn = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, TokensWithdrawn(amount: amount.description, from: address))
    }

    func testToSwiftValueEventWithNil() throws {
        // Arrange
        struct TokensWithdrawn: Codable, Equatable {
            let amount: String
            let from: Address?
        }
        let amount = Decimal(string: "0.00000169")!
        let value: Cadence.Value = .event(.init(
            id: "A.7e60df042a9c0868.FlowToken.TokensWithdrawn",
            fields: [
                .init(
                    name: "amount",
                    value: .ufix64(amount)),
                .init(
                    name: "from",
                    value: .optional(nil))
            ]
        ))

        // Act
        let result: TokensWithdrawn = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, TokensWithdrawn(amount: amount.description, from: nil))
    }

    func testToSwiftValueContract() throws {
        // Arrange
        struct FooContract: Codable, Equatable {
            let y: String
        }
        let value: Cadence.Value = .contract(.init(
            id: "s.test.FooContract",
            fields: [
                .init(
                    name: "y",
                    value: .string("bar")),
            ]
        ))

        // Act
        let result: FooContract = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, FooContract(y: "bar"))
    }

    func testToSwiftValueEnum() throws {
        // Arrange
        enum Color: UInt8, Codable, Equatable {
            case redColor
        }
        let value: Cadence.Value = .enum(.init(
            id: "s.ae56f5e3b7a20336e4a3b449847f6ddd39eafbc112bde5e170c97389f53625d4.Color",
            fields: [
                .init(
                    name: "rawValue",
                    value: .uint8(0)),
            ]
        ))

        // Act
        let result: Color = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, Color.redColor)
    }

    func testToSwiftValuePath() throws {
        // Arrange
        let path = Cadence.Path(domain: .public, identifier: "QQ")
        let value: Cadence.Value = .path(path)

        // Act
        let result: Path = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, path)
    }

    func testToSwiftValueType() throws {
        // Arrange
        let staticType = StaticTypeValue(staticType: .string)
        let value: Cadence.Value = .type(staticType)

        // Act
        let result: FType = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, staticType.staticType)
    }

    func testToSwiftValueCapability() throws {
        // Arrange
        let capability = Capability(
            path: "path",
            address: Address(hexString: "0xcb2d04fc89307107"),
            borrowType: .fix64)
        let value: Cadence.Value = .capability(capability)

        // Act
        let result: Capability = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, capability)
    }

    func testCustomStringConvertible() throws {
        // Given:
        let ufix64 = Decimal(string: "64.01")!
        let fix64 = Decimal(string: "-32.11")!

        // When & Then:
        XCTAssertEqual(Value.uint(10).description, "10")
        XCTAssertEqual(Value.uint8(8).description, "8")
        XCTAssertEqual(Value.uint16(16).description, "16")
        XCTAssertEqual(Value.uint32(32).description, "32")
        XCTAssertEqual(Value.uint64(64).description, "64")
        XCTAssertEqual(Value.uint128(128).description, "128")
        XCTAssertEqual(Value.uint256(256).description, "256")
        XCTAssertEqual(Value.int(1000000).description, "1000000")
        XCTAssertEqual(Value.int8(-8).description, "-8")
        XCTAssertEqual(Value.int16(-16).description, "-16")
        XCTAssertEqual(Value.int32(-32).description, "-32")
        XCTAssertEqual(Value.int64(-64).description, "-64")
        XCTAssertEqual(Value.int128(-128).description, "-128")
        XCTAssertEqual(Value.int256(-256).description, "-256")
        XCTAssertEqual(Value.word8(8).description, "8")
        XCTAssertEqual(Value.word16(16).description, "16")
        XCTAssertEqual(Value.word32(32).description, "32")
        XCTAssertEqual(Value.word64(64).description, "64")
        XCTAssertEqual(Value.ufix64(ufix64).description, "64.01000000")
        XCTAssertEqual(Value.fix64(fix64).description, "-32.11000000")
        XCTAssertEqual(Value.void.description, "()")
        XCTAssertEqual(Value.bool(true).description, "true")
        XCTAssertEqual(Value.bool(false).description, "false")
        XCTAssertEqual(Value.optional(.ufix64(ufix64)).description, "64.01000000")
        XCTAssertEqual(Value.optional(nil).description, "nil")
        XCTAssertEqual(Value.string("Flow ridah!").description, "\"Flow ridah!\"")
        XCTAssertEqual(Value.array([
            .int(10),
            .string("TEST")]
        ).description, "[10, \"TEST\"]")
        XCTAssertEqual(Value.dictionary([
            .init(key: .string("key"), value: .string("value"))
        ]).description, "{\"key\": \"value\"}")
        XCTAssertEqual(Value.address(
            Address(data: Data([0, 0, 0, 0, 0, 0, 0, 1]))
        ).description, "0x0000000000000001")
        XCTAssertEqual(Value.struct(.init(
            id: "S.test.FooStruct",
            fields: [
                .init(name: "y", value: .string("bar"))
            ])
        ).description, "S.test.FooStruct(y: \"bar\")")
        XCTAssertEqual(Value.resource(.init(
            id: "S.test.FooResource",
            fields: [
                .init(name: "bar", value: .int(1))
            ])
        ).description, "S.test.FooResource(bar: 1)")
        XCTAssertEqual(Value.event(.init(
            id: "S.test.FooEvent",
            fields: [
                .init(name: "a", value: .int(1)),
                .init(name: "b", value: .string("foo"))
            ])
        ).description, "S.test.FooEvent(a: 1, b: \"foo\")")
        XCTAssertEqual(Value.contract(.init(
            id: "S.test.FooContract",
            fields: [
                .init(name: "y", value: .string("bar"))
            ])
        ).description, "S.test.FooContract(y: \"bar\")")
        XCTAssertEqual(Value.path(
            .init(domain: .storage, identifier: "foo")
        ).description, "/storage/foo")
        XCTAssertEqual(Value.type(
            .init(staticType: .int)
        ).description, "Type<Int>()")
        XCTAssertEqual(Value.capability(
            .init(
                path: "/storage/foo",
                address: Address(data: Data([1, 2, 3, 4, 5])),
                borrowType: .int)
        ).description, "Capability<Int>(address: 0x0000000102030405, path: /storage/foo)")
    }

    func testToSwiftValueDecodable() throws {
        // Arrange
        struct TestStruct: Codable, Equatable {
            let value: Decimal

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let value = try container.decode(String.self, forKey: .value)
                self.value = Decimal(string: value) ?? 0
            }

            init(value: Decimal) {
                self.value = value
            }
        }
        let decimalValue = Decimal(string: "0.007601")!
        let value: Cadence.Value = .optional(.struct(
            id: "id",
            fields: [
                .init(name: "value", value: .ufix64(decimalValue)),
            ])
        )

        // Act
        let result: TestStruct = try value.toSwiftValue()

        // Assert
        XCTAssertEqual(result, TestStruct(value: decimalValue))
    }

}
