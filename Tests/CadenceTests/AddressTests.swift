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
        XCTAssertEqual(Address(hexString: "123").data.bytes, Data([0x1, 0x23]).bytes)
        XCTAssertEqual(Address(hexString: "1").data, Data([0x1]))
        XCTAssertEqual(Address(hexString: "01").data, Data([0x1]))
    }

}
