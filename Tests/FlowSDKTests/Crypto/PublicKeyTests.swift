//
//  PublicKeyTests.swift
// 
//  Created by Scott on 2022/6/5.
//  Copyright © 2022 portto. All rights reserved.
//

import XCTest
@testable import FlowSDK

final class PublicKeyTests: XCTestCase {

    func testECDSAP256() throws {
        // Arrange
        let hexText = "4d46d1a9f301d2eb5e7e05cfebf7abb69da67ca5056d81baeac60940349ec2f73f4b31757de1ffe66cedf0743cf78249ae63fdfa76c4f49f234e903a68dff2f6"
        let data = Data(hex: hexText)

        // Act
        let result = try PublicKey(data: data, signatureAlgorithm: .ecdsaP256)

        // Assert
        XCTAssertEqual(result.data, data)
        XCTAssertEqual(result.size, 64)
        XCTAssertEqual(result.algorithm, .ecdsaP256)
        XCTAssertEqual(result.hexString, hexText)
        XCTAssertEqual(result.description, hexText)
    }

    func testECDSASECP256k1() throws {
        // Arrange
        let hexText = "f0f493b8dbaee23049d456590d20e0da04e28362b0eb6ae2f29b575711e0d803ee30ce467e5d4d6c19ec39418db0ecf94b9707eee2110215b702a2b572e84218"
        let data = Data(hex: hexText)

        // Act
        let result = try PublicKey(data: data, signatureAlgorithm: .ecdsaSecp256k1)

        // Assert
        XCTAssertEqual(result.data, data)
        XCTAssertEqual(result.size, 64)
        XCTAssertEqual(result.algorithm, .ecdsaSecp256k1)
        XCTAssertEqual(result.hexString, hexText)
        XCTAssertEqual(result.description, hexText)
    }

    func testECDSASECP256k1WithPrefix() throws {
        // Arrange
        let hexText1 = "f0f493b8dbaee23049d456590d20e0da04e28362b0eb6ae2f29b575711e0d803ee30ce467e5d4d6c19ec39418db0ecf94b9707eee2110215b702a2b572e84218"
        let hexText2 = "04f0f493b8dbaee23049d456590d20e0da04e28362b0eb6ae2f29b575711e0d803ee30ce467e5d4d6c19ec39418db0ecf94b9707eee2110215b702a2b572e84218"
        let data1 = Data(hex: hexText1)
        let data2 = Data(hex: hexText2)

        // Act
        let key1 = try PublicKey(data: data1, signatureAlgorithm: .ecdsaSecp256k1)
        let key2 = try PublicKey(data: data2, signatureAlgorithm: .ecdsaSecp256k1)

        // Assert
        XCTAssertEqual(key1, key2)
    }

    func testECDSAP256Sha2256Verify() throws {
        // Arrange
        let message = "ABC".data(using: .utf8)!
        let rawKey = Data(hex: "e4784fd7cac1a5b3647119e02247c029e5c4d574943703297e23dc7bd00ab2ce25552ad544eacb956c81b02234742d5f8753165d542f3870705f585a4d93c371")
        let publicKey = try PublicKey(
            data: rawKey,
            signatureAlgorithm: .ecdsaP256)
        let signature = Data(hex: "710979fbfb6aa41b62e418f6f802a1ba8bea0a7228aab3450aab3577be3a0c07536a4b76afed839f16895e6b6225d1b2ec5faef4dda2bd1f94239fbe059bf064")

        // Act
        let result = try publicKey.verify(
            signature: signature,
            message: message,
            hashAlgorithm: .sha2_256)

        // Assert
        XCTAssertTrue(result)
    }

    func testECDSAP256Sha3256Verify() throws {
        // Arrange
        let message = "ABC".data(using: .utf8)!
        let rawKey = Data(hex: "c4ad1364dbd386316767b9efdad226d9f4bdb0d3371f6bbb02ed4444e9458110149363709b783afec9b6b39f180970d9fb79a8e0397941e02de4c25916734b1a")
        let publicKey = try PublicKey(
            data: rawKey,
            signatureAlgorithm: .ecdsaP256)
        let signature = Data(hex: "f62d6304a965df643c14de8e2f059e6cbf8051bad77b66862f7f7b108ac37dd085012e66b5f10ade34eb9f88994bb1092039749da0b5621e55083f4dcf7a3436")

        // Act
        let result = try publicKey.verify(
            signature: signature,
            message: message,
            hashAlgorithm: .sha3_256)

        // Assert
        XCTAssertTrue(result)
    }

    func testECDSASecp256k1Sha2256Verify() throws {
        // Arrange
        let message = "ABC".data(using: .utf8)!
        let rawKey = Data(hex: "ca9f859498165d504adb2ac25dcbd547e9eb32d76305c22e2f4ab52439cbd27057dd0eb34675d1fc71ec6240f7e718b9360a73c88b24f3ff67f9c7846bd87e94")
        let publicKey = try PublicKey(
            data: rawKey,
            signatureAlgorithm: .ecdsaSecp256k1)
        let signature = Data(hex: "8521e3d93705b0aa093ee032de7fbb6abf9d78376a510c77bfae1d0f7449230dd9519545d42b2ff8e060e472e96a8f412fffc0d8c54fc41cbc86e5762add088c")

        // Act
        let result = try publicKey.verify(
            signature: signature,
            message: message,
            hashAlgorithm: .sha2_256)

        // Assert
        XCTAssertTrue(result)
    }

    func testECDSASecp256k1Sha3256Verify() throws {
        // Arrange
        // 0xd6a7f5323ad4410e5b55d8d4450e46755a47bc82ceb0cb342c4f7b29feff9257
        let message = "ABC".data(using: .utf8)!
        let rawKey = Data(hex: "e813f199f08207784f823ea0246eb6dac7e8e61330dc3f677fda52b992dc31953b2ae7a2e5d96ab92f2dd19eba58dae7c9286f4f4e6a079fa98d3deee192a78a")
        let publicKey = try PublicKey(
            data: rawKey,
            signatureAlgorithm: .ecdsaSecp256k1)
        let signature = Data(hex: "6cfe0ce2c5bf71a187ddcd7ecb639d9477b4e37f8ee4081701540ff66fd07396a81f8b5a14cfe6df73ac1d6fcf0bf8b30c2a948bf2a8d2df87b4bc614b206483")

        // Act
        let result = try publicKey.verify(
            signature: signature,
            message: message,
            hashAlgorithm: .sha3_256)

        // Assert
        XCTAssertTrue(result)
    }

}
