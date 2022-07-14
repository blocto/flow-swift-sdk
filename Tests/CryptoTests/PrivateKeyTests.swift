//
//  PrivateKeyTests.swift
//
//  Created by Scott on 2022/6/5.
//  Copyright © 2022 portto. All rights reserved.
//

import XCTest
@testable import Crypto

final class PrivateKeyTests: XCTestCase {

    func testECDSAP256() throws {
        // Arrange
        let rawKey = Data(hex: "a7dc70afa6feae50093c87a01495cfafccac3cdadeee1f5c9e4f47a5111ae757")

        // Act
        let privateKey = try PrivateKey(data: rawKey, signatureAlgorithm: .ecdsaP256)

        // Assert
        XCTAssertEqual(privateKey.data, rawKey)
        let expectedPublicKey = "62f08d451022b9f4db449a04add774223c59d34b944b0eb33f20e96dbff4c33ba4efa10df35bc79e8c9cabb120c457ba28e33d13c88c65cc02bc9d70adf156da"
        XCTAssertEqual(privateKey.publicKey.hexString, expectedPublicKey)
    }

    func testECDSASECP256k1() throws {
        // Arrange
        let rawKey = Data(hex: "3968d37c7a6937e3cb0d8840f43710fb13b1f6f746e8650d985579d9a0e89e7b")

        // Act
        let privateKey = try PrivateKey(data: rawKey, signatureAlgorithm: .ecdsaSecp256k1)

        // Assert
        XCTAssertEqual(privateKey.data, rawKey)
        let expectedPublicKey = "935b03da17972da239e764b7679e14bb5c664f886f254517048fb17efa7784b6d12c68e7d741836fb48716087681d0c5a5837cf4082fb0bf0ba36bd44b5b8f64"
        XCTAssertEqual(privateKey.publicKey.hexString, expectedPublicKey)
    }

    func testSign() throws {
        // Arrange
        let hashAlgorithms: [HashAlgorithm] = [.sha2_256, .sha3_256]
        let signatureAlgorithms: [SignatureAlgorithm] = [.ecdsaP256, .ecdsaSecp256k1]
        let rawKey = Data(hex: "80aa5dc9cf71e401dddfecf326b646d0c6bbedc0d9ad00ccfc02c2c32a3b44fa")
        let message = "ABC".data(using: .utf8)!

        try signatureAlgorithms.forEach { signatureAlgorithm in
            // Arrange
            let privateKey = try PrivateKey(data: rawKey, signatureAlgorithm: signatureAlgorithm)

            try hashAlgorithms.forEach { hashAlgorithm in
                // Act
                let sigature = try privateKey.sign(message: message, hashAlgorithm: hashAlgorithm)
                let result = try privateKey.publicKey.verify(
                    signature: sigature,
                    message: message,
                    hashAlgorithm: hashAlgorithm)

                // Assert
                XCTAssertTrue(result)

                // Act
                var fakeSignature = sigature
                fakeSignature[0] += 1
                let result2 = try privateKey.publicKey.verify(
                    signature: fakeSignature,
                    message: message,
                    hashAlgorithm: hashAlgorithm)

                // Assert
                XCTAssertFalse(result2)
            }
        }
    }

}
