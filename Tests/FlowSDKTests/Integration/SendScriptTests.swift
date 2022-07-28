//
//  SendScriptTests.swift
//
//  Created by Scott on 2022/7/15.
//  Copyright © 2022 portto. All rights reserved.
//

import XCTest
import Cadence
@testable import FlowSDK

final class SendScriptTests: XCTestCase {

    private var client: Client!

    override func setUpWithError() throws {
        client = Client(network: .testnet)
    }

    override func tearDownWithError() throws {
        client = nil
    }

    func testFlowPing() async throws {
        try await client.ping()
    }

    func testFlowFee() async throws {
        // Act
        let result = try await client.executeScriptAtLatestBlock(
            script: try Utils.getTestData(name: "getFlowFees.cdc"),
            arguments: []
        )

        // Assert
        XCTAssertEqual(result, .struct(
            id: "A.912d5440f7e3769e.FlowFees.FeeParameters",
            fields: [
                .init(name: "surgeFactor", value: .ufix64(Decimal(string: "1")!)),
                .init(name: "inclusionEffortCost", value: .ufix64(Decimal(string: "0.000001")!)),
                .init(name: "executionEffortCost", value: .ufix64(Decimal(string: "4.99049905")!)),
            ]
        ))
    }

}
