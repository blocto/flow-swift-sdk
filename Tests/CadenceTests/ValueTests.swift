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

    func testDecodeVoid() throws {
        // Given:
        let jsonData = """
        {
          "type": "Void"
        }
        """.data(using: .utf8)!

        // When
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .void)
        XCTAssertEqual(value.type, .void)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .optional(.uint8(123)))
        XCTAssertEqual(value.type, .optional)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .optional(nil))
        XCTAssertEqual(value.type, .optional)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .bool(true))
        XCTAssertEqual(value.type, .bool)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .string("Hello, world!"))
        XCTAssertEqual(value.type, .string)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .address(Address(hexString: "0x1234")))
        XCTAssertEqual(value.type, .address)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .int(BigInt("-123")))
        XCTAssertEqual(value.type, .int)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .uint(BigUInt("123")))
        XCTAssertEqual(value.type, .uint)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .int8(-8))
        XCTAssertEqual(value.type, .int8)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .uint8(8))
        XCTAssertEqual(value.type, .uint8)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .int16(-16))
        XCTAssertEqual(value.type, .int16)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .uint16(16))
        XCTAssertEqual(value.type, .uint16)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .int32(-32))
        XCTAssertEqual(value.type, .int32)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .uint32(32))
        XCTAssertEqual(value.type, .uint32)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .int64(-64))
        XCTAssertEqual(value.type, .int64)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .uint64(64))
        XCTAssertEqual(value.type, .uint64)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .int128(BigInt("-128")))
        XCTAssertEqual(value.type, .int128)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .uint128(BigUInt("128")))
        XCTAssertEqual(value.type, .uint128)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .int256(BigInt("-256")))
        XCTAssertEqual(value.type, .int256)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .uint256(BigUInt("256")))
        XCTAssertEqual(value.type, .uint256)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .word8(8))
        XCTAssertEqual(value.type, .word8)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .word16(16))
        XCTAssertEqual(value.type, .word16)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .word32(32))
        XCTAssertEqual(value.type, .word32)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .word64(64))
        XCTAssertEqual(value.type, .word64)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .fix64(Decimal(string: "-12.3")!))
        XCTAssertEqual(value.type, .fix64)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .ufix64(Decimal(string: "12.3")!))
        XCTAssertEqual(value.type, .ufix64)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .array([
            .int16(123),
            .string("test"),
            .bool(true)
        ]))
        XCTAssertEqual(value.type, .array)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .dictionary([
            .init(key: .uint8(123), value: .string("test"))
        ]))
        XCTAssertEqual(value.type, .dictionary)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .struct(.init(
            id: "s.5a312c0cf513ac0b3464c980e7c61d9d7fedd8cde2fa64ad0c617344fb993bf4.Fruit",
            fields: [
                .init(name: "name", value: .string("Apple"))
            ])))
        XCTAssertEqual(value.type, .struct)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .resource(.init(
            id: "0x3.GreatContract.GreatNFT",
            fields: [
                .init(name: "power", value: .int(1))
            ])))
        XCTAssertEqual(value.type, .resource)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .event(.init(
            id: "A.7e60df042a9c0868.FlowToken.TokensWithdrawn",
            fields: [
                .init(name: "amount", value: .ufix64(Decimal(string: "0.00000169")!)),
                .init(name: "from", value: .optional(.address(Address(hexString: "0xebf4ae01d1284af8"))))
            ])))
        XCTAssertEqual(value.type, .event)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .contract(.init(
            id: "s.test.FooContract",
            fields: [
                .init(name: "y", value: .string("bar"))
            ])))
        XCTAssertEqual(value.type, .contract)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .enum(.init(
            id: "s.ae56f5e3b7a20336e4a3b449847f6ddd39eafbc112bde5e170c97389f53625d4.Color",
            fields: [
                .init(name: "rawValue", value: .uint8(0))
            ])))
        XCTAssertEqual(value.type, .enum)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .path(
            .init(
                domain: .storage,
                identifier: "flowTokenVault"
            )
        ))
        XCTAssertEqual(value.type, .path)
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
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .type(.init(staticType: .int)))
        XCTAssertEqual(value.type, .type)
    }

    func testDecodeCapability() throws {
        // Given:
        let jsonData = """
        {
          "type": "Capability",
          "value": {
            "path": "/public/someInteger",
            "address": "0x1",
            "borrowType": {
              "kind": "Int"
            },
          }
        }
        """.data(using: .utf8)!

        // When
        let value = try Value.decode(data: jsonData)

        // Then
        XCTAssertEqual(value, .capability(
            .init(
                path: "/public/someInteger",
                address: Address(hexString: "0x1"),
                borrowType: .int
            )
        ))
        XCTAssertEqual(value.type, .capability)
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
        let value = try Value.decode(data: jsonData)

        // Then
        let resource = CompositeType(
            type: "",
            typeId: "0x3.GreatContract.NFT",
            initializers: [],
            fields: [])
        let type = StaticType.resource(resource)
        resource.fields = [
            .init(id: "foo", type: .optional(type))
        ]
        XCTAssertEqual(value, .type(
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
        XCTAssertEqual(value.type, .type)
    }

}
