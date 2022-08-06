//
//  RLPDecoderTests.swift
// 
//  Created by Scott on 2022/8/6.
//  Copyright © 2022 portto. All rights reserved.
//

import XCTest
import FlowSDK
import BigInt

final class RLPDecoderTests: XCTestCase {

    private var sut: RLPDecoder!

    override func setUpWithError() throws {
        sut = RLPDecoder()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testBool() throws {
        XCTAssertEqual(
            try Bool(rlpItem: try sut.decodeRLPData(Data(hex: "01"))),
            true)
        XCTAssertEqual(
            try Bool(rlpItem: try sut.decodeRLPData(Data(hex: "80"))),
            false)
    }

    func testUnsignedInteger() throws {
        XCTAssertEqual(
            try UInt(rlpItem: try sut.decodeRLPData(Data(hex: "80"))),
            0)
        XCTAssertEqual(
            try UInt(rlpItem: try sut.decodeRLPData(Data(hex: "7f"))),
            127)
        XCTAssertEqual(
            try UInt(rlpItem: try sut.decodeRLPData(Data(hex: "8180"))),
            128)
        XCTAssertEqual(
            try UInt(rlpItem: try sut.decodeRLPData(Data(hex: "820100"))),
            256)
        XCTAssertEqual(
            try UInt(rlpItem: try sut.decodeRLPData(Data(hex: "820400"))),
            1024)
        XCTAssertEqual(
            try UInt(rlpItem: try sut.decodeRLPData(Data(hex: "83ffffff"))),
            0xFFFFFF)
        XCTAssertEqual(
            try UInt(rlpItem: try sut.decodeRLPData(Data(hex: "84ffffffff"))),
            0xFFFFFFFF)
        XCTAssertEqual(
            try UInt(rlpItem: try sut.decodeRLPData(Data(hex: "85ffffffffff"))),
            0xFFFFFFFFFF)
        XCTAssertEqual(
            try UInt(rlpItem: try sut.decodeRLPData(Data(hex: "86ffffffffffff"))),
            0xFFFFFFFFFFFF)
        XCTAssertEqual(
            try UInt(rlpItem: try sut.decodeRLPData(Data(hex: "87ffffffffffffff"))),
            0xFFFFFFFFFFFFFF)
        XCTAssertEqual(
            try UInt64(rlpItem: try sut.decodeRLPData(Data(hex: "88ffffffffffffffff"))),
            0xFFFFFFFFFFFFFFFF)
    }

    func testBigUInt() throws {
        XCTAssertEqual(
            try BigUInt(rlpItem: try sut.decodeRLPData(Data(hex: "80"))),
            BigUInt(0))
        XCTAssertEqual(
            try BigUInt(rlpItem: try sut.decodeRLPData(Data(hex: "01"))),
            BigUInt(1))
        XCTAssertEqual(
            try BigUInt(rlpItem: try sut.decodeRLPData(Data(hex: "7f"))),
            BigUInt(127))
        XCTAssertEqual(
            try BigUInt(rlpItem: try sut.decodeRLPData(Data(hex: "8180"))),
            BigUInt(128))
        XCTAssertEqual(
            try BigUInt(rlpItem: try sut.decodeRLPData(Data(hex: "820100"))),
            BigUInt(256))
        XCTAssertEqual(
            try BigUInt(rlpItem: try sut.decodeRLPData(Data(hex: "820400"))),
            BigUInt(1024))
        XCTAssertEqual(
            try BigUInt(rlpItem: try sut.decodeRLPData(Data(hex: "83ffffff"))),
            BigUInt(0xFFFFFF))
        XCTAssertEqual(
            try BigUInt(rlpItem: try sut.decodeRLPData(Data(hex: "84ffffffff"))),
            BigUInt(0xFFFFFFFF))
        XCTAssertEqual(
            try BigUInt(rlpItem: try sut.decodeRLPData(Data(hex: "85ffffffffff"))),
            BigUInt(0xFFFFFFFFFF))
        XCTAssertEqual(
            try BigUInt(rlpItem: try sut.decodeRLPData(Data(hex: "86ffffffffffff"))),
            BigUInt(0xFFFFFFFFFFFF))
        XCTAssertEqual(
            try BigUInt(rlpItem: try sut.decodeRLPData(Data(hex: "87ffffffffffffff"))),
            BigUInt(0xFFFFFFFFFFFFFF))
        XCTAssertEqual(
            try BigUInt(rlpItem: try sut.decodeRLPData(Data(hex: "8f102030405060708090a0b0c0d0e0f2"))),
            BigUInt("83729609699884896815286331701780722"))
        XCTAssertEqual(
            try BigUInt(rlpItem: try sut.decodeRLPData(Data(hex: "9c0100020003000400050006000700080009000a000b000c000d000e01"))),
            BigUInt("105315505618206987246253880190783558935785933862974822347068935681"))
        XCTAssertEqual(
            try BigUInt(rlpItem: try sut.decodeRLPData(Data(hex: "a1010000000000000000000000000000000000000000000000000000000000000000"))),
            BigUInt("115792089237316195423570985008687907853269984665640564039457584007913129639936"))
    }

    func testData() throws {
        XCTAssertEqual(
            try Data(rlpItem: try sut.decodeRLPData(Data(hex: "80"))),
            Data())
        XCTAssertEqual(
            try Data(rlpItem: try sut.decodeRLPData(Data(hex: "7e"))),
            Data([0x7E]))
        XCTAssertEqual(
            try Data(rlpItem: try sut.decodeRLPData(Data(hex: "7f"))),
            Data([0x7F]))
        XCTAssertEqual(
            try Data(rlpItem: try sut.decodeRLPData(Data(hex: "8180"))),
            Data([0x80]))
        XCTAssertEqual(
            try Data(rlpItem: try sut.decodeRLPData(Data(hex: "83010203"))),
            Data([1, 2, 3]))
    }

    func testString() throws {
        XCTAssertEqual(
            try String(rlpItem: try sut.decodeRLPData(Data(hex: "80"))),
            "")
        XCTAssertEqual(
            try String(rlpItem: try sut.decodeRLPData(Data(hex: "83646f67"))),
            "dog")
        XCTAssertEqual(
            try String(rlpItem: try sut.decodeRLPData(Data(hex: "b74c6f72656d20697073756d20646f6c6f722073697420616d65742c20636f6e7365637465747572206164697069736963696e6720656c69"))),
            "Lorem ipsum dolor sit amet, consectetur adipisicing eli")
        XCTAssertEqual(
            try String(rlpItem: try sut.decodeRLPData(Data(hex: "b8384c6f72656d20697073756d20646f6c6f722073697420616d65742c20636f6e7365637465747572206164697069736963696e6720656c6974"))),
            "Lorem ipsum dolor sit amet, consectetur adipisicing elit")
        XCTAssertEqual(
            try String(rlpItem: try sut.decodeRLPData(Data(hex: "b904004c6f72656d20697073756d20646f6c6f722073697420616d65742c20636f6e73656374657475722061646970697363696e6720656c69742e20437572616269747572206d6175726973206d61676e612c20737573636970697420736564207665686963756c61206e6f6e2c20696163756c697320666175636962757320746f72746f722e2050726f696e20737573636970697420756c74726963696573206d616c6573756164612e204475697320746f72746f7220656c69742c2064696374756d2071756973207472697374697175652065752c20756c7472696365732061742072697375732e204d6f72626920612065737420696d70657264696574206d6920756c6c616d636f7270657220616c6971756574207375736369706974206e6563206c6f72656d2e2041656e65616e2071756973206c656f206d6f6c6c69732c2076756c70757461746520656c6974207661726975732c20636f6e73657175617420656e696d2e204e756c6c6120756c74726963657320747572706973206a7573746f2c20657420706f73756572652075726e6120636f6e7365637465747572206e65632e2050726f696e206e6f6e20636f6e76616c6c6973206d657475732e20446f6e65632074656d706f7220697073756d20696e206d617572697320636f6e67756520736f6c6c696369747564696e2e20566573746962756c756d20616e746520697073756d207072696d697320696e206661756369627573206f726369206c756374757320657420756c74726963657320706f737565726520637562696c69612043757261653b2053757370656e646973736520636f6e76616c6c69732073656d2076656c206d617373612066617563696275732c2065676574206c6163696e6961206c616375732074656d706f722e204e756c6c61207175697320756c747269636965732070757275732e2050726f696e20617563746f722072686f6e637573206e69626820636f6e64696d656e74756d206d6f6c6c69732e20416c697175616d20636f6e73657175617420656e696d206174206d65747573206c75637475732c206120656c656966656e6420707572757320656765737461732e20437572616269747572206174206e696268206d657475732e204e616d20626962656e64756d2c206e6571756520617420617563746f72207472697374697175652c206c6f72656d206c696265726f20616c697175657420617263752c206e6f6e20696e74657264756d2074656c6c7573206c65637475732073697420616d65742065726f732e20437261732072686f6e6375732c206d65747573206163206f726e617265206375727375732c20646f6c6f72206a7573746f20756c747269636573206d657475732c20617420756c6c616d636f7270657220766f6c7574706174"))),
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur mauris magna, suscipit sed vehicula non, iaculis faucibus tortor. Proin suscipit ultricies malesuada. Duis tortor elit, dictum quis tristique eu, ultrices at risus. Morbi a est imperdiet mi ullamcorper aliquet suscipit nec lorem. Aenean quis leo mollis, vulputate elit varius, consequat enim. Nulla ultrices turpis justo, et posuere urna consectetur nec. Proin non convallis metus. Donec tempor ipsum in mauris congue sollicitudin. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Suspendisse convallis sem vel massa faucibus, eget lacinia lacus tempor. Nulla quis ultricies purus. Proin auctor rhoncus nibh condimentum mollis. Aliquam consequat enim at metus luctus, a eleifend purus egestas. Curabitur at nibh metus. Nam bibendum, neque at auctor tristique, lorem libero aliquet arcu, non interdum tellus lectus sit amet eros. Cras rhoncus, metus ac ornare cursus, dolor justo ultrices metus, at ullamcorper volutpat")
    }

    func testList() throws {
        var result: [RLPItem]!

        result = try sut.decodeRLPData(Data(hex: "c0")).getListItems()
        XCTAssertEqual(
            result,
            [])

        result = try sut.decodeRLPData(Data(hex: "c180")).getListItems()
        XCTAssertEqual(
            try UInt(rlpItem: result[0]),
            0)

        result = try sut.decodeRLPData(Data(hex: "c180")).getListItems()
        XCTAssertEqual(
            try BigUInt(rlpItem: result[0]),
            0)

        result = try sut.decodeRLPData(Data(hex: "c3010203")).getListItems()
        XCTAssertEqual(
            try UInt(rlpItem: result[0]),
            1)
        XCTAssertEqual(
            try UInt(rlpItem: result[1]),
            2)
        XCTAssertEqual(
            try UInt(rlpItem: result[2]),
            3)

        // [ [], [[]], [ [], [[]] ] ]
        result = try sut.decodeRLPData(Data(hex: "c7c0c1c0c3c0c1c0")).getListItems()
        XCTAssertEqual(
            try result[0].getListItems(),
            [])
        XCTAssertEqual(
            try result[1].getListItems()[0].getListItems(),
            [])
        XCTAssertEqual(
            try result[2].getListItems()[0].getListItems(),
            [])
        XCTAssertEqual(
            try result[2].getListItems()[1].getListItems()[0].getListItems(),
            [])

        result = try sut.decodeRLPData(Data(hex: "f83c836161618362626283636363836464648365656583666666836767678368686883696969836a6a6a836b6b6b836c6c6c836d6d6d836e6e6e836f6f6f")).getListItems()
        XCTAssertEqual(
            try result.map { try String(rlpItem: $0) },
            ["aaa", "bbb", "ccc", "ddd", "eee", "fff", "ggg", "hhh", "iii", "jjj", "kkk", "lll", "mmm", "nnn", "ooo"])

        result = try sut.decodeRLPData(Data(hex: "ce0183ffffffc4c304050583616263")).getListItems()
        XCTAssertEqual(
            try UInt(rlpItem: result[0]),
            1)
        XCTAssertEqual(
            try UInt(rlpItem: result[1]),
            0xFFFFFF)
        XCTAssertEqual(
            try result[2].getListItems()[0].getListItems().map { try UInt(rlpItem: $0) },
            [4, 5, 5])
        XCTAssertEqual(
            try String(rlpItem: result[3]),
            "abc")

        result = try sut.decodeRLPData(Data(hex: "f90200cf84617364668471776572847a786376cf84617364668471776572847a786376cf84617364668471776572847a786376cf84617364668471776572847a786376cf84617364668471776572847a786376cf84617364668471776572847a786376cf84617364668471776572847a786376cf84617364668471776572847a786376cf84617364668471776572847a786376cf84617364668471776572847a786376cf84617364668471776572847a786376cf84617364668471776572847a786376cf84617364668471776572847a786376cf84617364668471776572847a786376cf84617364668471776572847a786376cf84617364668471776572847a786376cf84617364668471776572847a786376cf84617364668471776572847a786376cf84617364668471776572847a786376cf84617364668471776572847a786376cf84617364668471776572847a786376cf84617364668471776572847a786376cf84617364668471776572847a786376cf84617364668471776572847a786376cf84617364668471776572847a786376cf84617364668471776572847a786376cf84617364668471776572847a786376cf84617364668471776572847a786376cf84617364668471776572847a786376cf84617364668471776572847a786376cf84617364668471776572847a786376cf84617364668471776572847a786376")).getListItems()
        XCTAssertEqual(
            try result.map { try $0.getListItems().map { try String(rlpItem: $0) } },
            [
                ["asdf", "qwer", "zxcv"],
                ["asdf", "qwer", "zxcv"],
                ["asdf", "qwer", "zxcv"],
                ["asdf", "qwer", "zxcv"],
                ["asdf", "qwer", "zxcv"],
                ["asdf", "qwer", "zxcv"],
                ["asdf", "qwer", "zxcv"],
                ["asdf", "qwer", "zxcv"],
                ["asdf", "qwer", "zxcv"],
                ["asdf", "qwer", "zxcv"],
                ["asdf", "qwer", "zxcv"],
                ["asdf", "qwer", "zxcv"],
                ["asdf", "qwer", "zxcv"],
                ["asdf", "qwer", "zxcv"],
                ["asdf", "qwer", "zxcv"],
                ["asdf", "qwer", "zxcv"],
                ["asdf", "qwer", "zxcv"],
                ["asdf", "qwer", "zxcv"],
                ["asdf", "qwer", "zxcv"],
                ["asdf", "qwer", "zxcv"],
                ["asdf", "qwer", "zxcv"],
                ["asdf", "qwer", "zxcv"],
                ["asdf", "qwer", "zxcv"],
                ["asdf", "qwer", "zxcv"],
                ["asdf", "qwer", "zxcv"],
                ["asdf", "qwer", "zxcv"],
                ["asdf", "qwer", "zxcv"],
                ["asdf", "qwer", "zxcv"],
                ["asdf", "qwer", "zxcv"],
                ["asdf", "qwer", "zxcv"],
                ["asdf", "qwer", "zxcv"],
                ["asdf", "qwer", "zxcv"],
            ])
    }

}
