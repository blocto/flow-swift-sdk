//
//  AddressTests.swift
//
//  Created by Scott on 2022/5/22.
//  Copyright © 2022 portto. All rights reserved.
//

import XCTest
import Cadence

final class AddressTests: XCTestCase {

    func testHexToAddress() throws {
        XCTAssertEqual(
            Address(hexString: "123").data,
            Data([0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x23]))
        XCTAssertEqual(
            Address(hexString: "1").data,
            Data([0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1]))
        XCTAssertEqual(
            Address(hexString: "01").data,
            Data([0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1]))
    }

    func testCodable() throws {
        // Arrange
        let address = Address(hexString: "0xe242ccfb4b8ea3e2")
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()

        // Act
        let result = try decoder.decode(
            Address.self,
            from: try encoder.encode(address))

        // Assert
        XCTAssertEqual(address, result)
    }

}
