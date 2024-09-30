//
//  ArgumentTests.swift
// 
//  Created by Scott on 2022/7/27.
//  Copyright © 2022 portto. All rights reserved.
//

import XCTest
import Cadence
import BigInt

final class ArgumentTests: XCTestCase {

    func testDecodeVoid() throws {
        // Given:
        let jsonData = """
        {
          "type": "Void"
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .void)
        XCTAssertEqual(argument.value, .void)
    }

    func testDecodeOptionalNonNil() throws {
        // Given:
        let jsonData = """
        {
          "type": "Optional",
          "value": {
            "type": "UInt8",
            "value": "123"
          }
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .optional)
        XCTAssertEqual(argument.value, .optional(.uint8(123)))
    }

    func testDecodeOptionalNil() throws {
        // Given:
        let jsonData = """
        {
          "type": "Optional",
          "value": null
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .optional)
        XCTAssertEqual(argument.value, .optional(nil))
    }

    func testDecodeBool() throws {
        // Given:
        let jsonData = """
        {
          "type": "Bool",
          "value": true
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .bool)
        XCTAssertEqual(argument.value, .bool(true))
    }

    func testDecodeString() throws {
        // Given:
        let jsonData = """
        {
          "type": "String",
          "value": "Hello, world!"
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .string)
        XCTAssertEqual(argument.value, .string("Hello, world!"))
    }

    func testDecodeAddress() throws {
        // Given:
        let jsonData = """
        {
          "type": "Address",
          "value": "0x1234"
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .address)
        XCTAssertEqual(argument.value, .address(Address(hexString: "0x1234")))
    }

    func testDecodeInt() throws {
        // Given:
        let jsonData = """
        {
          "type": "Int",
          "value": "-123"
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .int)
        XCTAssertEqual(argument.value, .int(BigInt("-123")))
    }

    func testDecodeUInt() throws {
        // Given:
        let jsonData = """
        {
          "type": "UInt",
          "value": "123"
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .uint)
        XCTAssertEqual(argument.value, .uint(BigUInt("123")))
    }

    func testDecodeInt8() throws {
        // Given:
        let jsonData = """
        {
          "type": "Int8",
          "value": "-8"
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .int8)
        XCTAssertEqual(argument.value, .int8(-8))
    }

    func testDecodeUInt8() throws {
        // Given:
        let jsonData = """
        {
          "type": "UInt8",
          "value": "8"
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .uint8)
        XCTAssertEqual(argument.value, .uint8(8))
    }

    func testDecodeInt16() throws {
        // Given:
        let jsonData = """
        {
          "type": "Int16",
          "value": "-16"
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .int16)
        XCTAssertEqual(argument.value, .int16(-16))
    }

    func testDecodeUInt16() throws {
        // Given:
        let jsonData = """
        {
          "type": "UInt16",
          "value": "16"
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .uint16)
        XCTAssertEqual(argument.value, .uint16(16))
    }

    func testDecodeInt32() throws {
        // Given:
        let jsonData = """
        {
          "type": "Int32",
          "value": "-32"
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .int32)
        XCTAssertEqual(argument.value, .int32(-32))
    }

    func testDecodeUInt32() throws {
        // Given:
        let jsonData = """
        {
          "type": "UInt32",
          "value": "32"
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .uint32)
        XCTAssertEqual(argument.value, .uint32(32))
    }

    func testDecodeInt64() throws {
        // Given:
        let jsonData = """
        {
          "type": "Int64",
          "value": "-64"
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .int64)
        XCTAssertEqual(argument.value, .int64(-64))
    }

    func testDecodeUInt64() throws {
        // Given:
        let jsonData = """
        {
          "type": "UInt64",
          "value": "64"
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .uint64)
        XCTAssertEqual(argument.value, .uint64(64))
    }

    func testDecodeInt128() throws {
        // Given:
        let jsonData = """
        {
          "type": "Int128",
          "value": "-128"
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .int128)
        XCTAssertEqual(argument.value, .int128(BigInt("-128")))
    }

    func testDecodeUInt128() throws {
        // Given:
        let jsonData = """
        {
          "type": "UInt128",
          "value": "128"
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .uint128)
        XCTAssertEqual(argument.value, .uint128(BigUInt("128")))
    }

    func testDecodeInt256() throws {
        // Given:
        let jsonData = """
        {
          "type": "Int256",
          "value": "-256"
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .int256)
        XCTAssertEqual(argument.value, .int256(BigInt("-256")))
    }

    func testDecodeUInt256() throws {
        // Given:
        let jsonData = """
        {
          "type": "UInt256",
          "value": "256"
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .uint256)
        XCTAssertEqual(argument.value, .uint256(BigUInt("256")))
    }

    func testDecodeWord8() throws {
        // Given:
        let jsonData = """
        {
          "type": "Word8",
          "value": "8"
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .word8)
        XCTAssertEqual(argument.value, .word8(8))
    }

    func testDecodeWord16() throws {
        // Given:
        let jsonData = """
        {
          "type": "Word16",
          "value": "16"
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .word16)
        XCTAssertEqual(argument.value, .word16(16))
    }

    func testDecodeWord32() throws {
        // Given:
        let jsonData = """
        {
          "type": "Word32",
          "value": "32"
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .word32)
        XCTAssertEqual(argument.value, .word32(32))
    }

    func testDecodeWord64() throws {
        // Given:
        let jsonData = """
        {
          "type": "Word64",
          "value": "64"
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .word64)
        XCTAssertEqual(argument.value, .word64(64))
    }

    func testDecodeFix64() throws {
        // Given:
        let jsonData = """
        {
            "type": "Fix64",
            "value": "-12.3"
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .fix64)
        XCTAssertEqual(argument.value, .fix64(Decimal(string: "-12.3")!))
    }

    func testDecodeUFix64() throws {
        // Given:
        let jsonData = """
        {
            "type": "UFix64",
            "value": "12.3"
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .ufix64)
        XCTAssertEqual(argument.value, .ufix64(Decimal(string: "12.3")!))
    }

    func testDecodeArray() throws {
        // Given:
        let jsonData = """
        {
          "type": "Array",
          "value": [
            {
              "type": "Int16",
              "value": "123"
            },
            {
              "type": "String",
              "value": "test"
            },
            {
              "type": "Bool",
              "value": true
            }
          ]
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .array)
        XCTAssertEqual(argument.value, .array([
            .int16(123),
            .string("test"),
            .bool(true)
        ]))
    }

    func testDecodeDictionary() throws {
        // Given:
        let jsonData = """
        {
          "type": "Dictionary",
          "value": [
            {
              "key": {
                "type": "UInt8",
                "value": "123"
              },
              "value": {
                "type": "String",
                "value": "test"
              }
            }
          ]
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .dictionary)
        XCTAssertEqual(argument.value, .dictionary([
            .init(
                key: .uint8(123),
                value: .string("test"))
        ]))
    }

    func testDecodeStruct() throws {
        // Given:
        let jsonData = """
        {
          "type": "Struct",
          "value": {
            "id": "s.5a312c0cf513ac0b3464c980e7c61d9d7fedd8cde2fa64ad0c617344fb993bf4.Fruit",
            "fields": [
              {
                "name": "name",
                "value": {
                  "type": "String",
                  "value": "Apple"
                }
              }
            ]
          }
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .struct)
        XCTAssertEqual(argument.value, .struct(.init(
            id: "s.5a312c0cf513ac0b3464c980e7c61d9d7fedd8cde2fa64ad0c617344fb993bf4.Fruit",
            fields: [
                .init(
                    name: "name",
                    value: .string("Apple"))
            ])))
    }

    func testDecodeResource() throws {
        // Given:
        let jsonData = """
        {
          "type": "Resource",
          "value": {
            "id": "0x3.GreatContract.GreatNFT",
            "fields": [
              {
                "name": "power",
                "value": {"type": "Int", "value": "1"}
              }
            ]
          }
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .resource)
        XCTAssertEqual(argument.value, .resource(.init(
            id: "0x3.GreatContract.GreatNFT",
            fields: [
                .init(
                    name: "power",
                    value: .int(1))
            ])))
    }

    func testDecodeEvent() throws {
        // Given:
        let jsonData = """
        {
          "type": "Event",
          "value": {
            "id": "A.7e60df042a9c0868.FlowToken.TokensWithdrawn",
            "fields": [
              {
                "name": "amount",
                "value": {
                  "type": "UFix64",
                  "value": "0.00000169"
                }
              },
              {
                "name": "from",
                "value": {
                  "type": "Optional",
                  "value": {
                    "type": "Address",
                    "value": "0xebf4ae01d1284af8"
                  }
                }
              }
            ]
          }
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .event)
        XCTAssertEqual(argument.value, .event(.init(
            id: "A.7e60df042a9c0868.FlowToken.TokensWithdrawn",
            fields: [
                .init(
                    name: "amount",
                    value: .ufix64(Decimal(string: "0.00000169")!)),
                .init(
                    name: "from",
                    value: .optional(.address(Address(hexString: "0xebf4ae01d1284af8"))))
            ])))
    }

    func testDecodeContract() throws {
        // Given:
        let jsonData = """
        {
          "type": "Contract",
          "value": {
            "id": "s.test.FooContract",
            "fields": [
              {
                "name": "y",
                "value": {
                  "type": "String",
                  "value": "bar"
                }
              }
            ]
          }
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .contract)
        XCTAssertEqual(argument.value, .contract(.init(
            id: "s.test.FooContract",
            fields: [
                .init(name: "y", value: .string("bar"))
            ])))
    }

    func testDecodeEnum() throws {
        // Given:
        let jsonData = """
        {
          "type": "Enum",
          "value": {
            "id": "s.ae56f5e3b7a20336e4a3b449847f6ddd39eafbc112bde5e170c97389f53625d4.Color",
            "fields": [
              {
                "name": "rawValue",
                "value": {
                  "type": "UInt8",
                  "value": "0"
                }
              }
            ]
          }
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .enum)
        XCTAssertEqual(argument.value, .enum(.init(
            id: "s.ae56f5e3b7a20336e4a3b449847f6ddd39eafbc112bde5e170c97389f53625d4.Color",
            fields: [
                .init(name: "rawValue", value: .uint8(0))
            ])))
    }

    func testDecodePath() throws {
        // Given:
        let jsonData = """
        {
          "type": "Path",
          "value": {
            "domain": "storage",
            "identifier": "flowTokenVault"
          }
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .path)
        XCTAssertEqual(argument.value, .path(
            .init(
                domain: .storage,
                identifier: "flowTokenVault"
            )
        ))
    }

    func testDecodeType() throws {
        // Given:
        let jsonData = """
        {
          "type": "Type",
          "value": {
            "staticType": {
              "kind": "Int",
            }
          }
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .type)
        XCTAssertEqual(argument.value, .type(.init(staticType: .int)))
    }

    func testDecodeCapability() throws {
        // Given:
        let jsonData = """
        {
          "type": "Capability",
          "value": {
            "id": "7",
            "address": "0x1",
            "borrowType": {
              "kind": "Int"
            },
          }
        }
        """.data(using: .utf8)!

        // When
        let argument = try Argument.decode(data: jsonData)

        // Then
        XCTAssertEqual(argument.type, .capability)
        XCTAssertEqual(argument.value, .capability(
            .init(
                id: "7",
                address: Address(hexString: "0x1"),
                borrowType: .int
            )
        ))
    }

    func testDecodeRepeatedType() throws {
        // Given:
        let jsonData = """
        {
          "type": "Type",
          "value": {
            "staticType": {
              "kind": "Resource",
              "typeID": "0x3.GreatContract.NFT",
              "fields": [
                {
                  "id": "foo",
                  "type": {
                    "kind": "Optional",
                    "type": "0x3.GreatContract.NFT"
                  }
                }
              ],
              "initializers": [],
              "type": ""
            }
          }
        }
        """.data(using: .utf8)!

        // When:
        let argument = try Argument.decode(data: jsonData)

        // Then
        let resource = CompositeType(
            type: "",
            typeId: "0x3.GreatContract.NFT",
            initializers: [],
            fields: [])
        let type = FType.resource(resource)
        resource.fields = [
            .init(id: "foo", type: .optional(type))
        ]
        XCTAssertEqual(argument.type, .type)
        XCTAssertEqual(argument.value, .type(
            .init(
                staticType: .resource(
                    .init(
                        type: "",
                        typeId: "0x3.GreatContract.NFT",
                        initializers: [],
                        fields: [
                            .init(
                                id: "foo",
                                type: .optional(type))
                        ]
                    )
                )
            )
        ))
    }
}
