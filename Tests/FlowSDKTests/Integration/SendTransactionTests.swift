//
//  SendTransactionTests.swift
//
//  Created by Scott on 2022/7/15.
//  Copyright © 2022 portto. All rights reserved.
//

import XCTest
import Cadence
import Crypto
@testable import FlowSDK

final class SendTransactionTests: XCTestCase {

    func testCreateAccount() throws {
        // Arrange
        let client = Client(network: .testnet)
        let address = Address(hexString: "0xe242ccfb4b8ea3e2")
        let rawKey = Data(hex: "1eb79c40023143821983dc79b4e639789ea42452e904fda719f5677a1f144208")
        let privateKey = try PrivateKey(data: rawKey, signatureAlgorithm: .ecdsaP256)

        let signer = InMemorySigner(privateKey: privateKey, hashAlgorithm: .sha2_256)
        guard let adminAccount = try client.getAccountAtLatestBlock(address: address).wait() else {
            XCTFail("adminAccount not found.")
            return
        }
        let selectedAccountKey = adminAccount.keys.first { $0.publicKey == privateKey.publicKey }
        guard let adminAccountKey = selectedAccountKey else {
            XCTFail("adminAccountKey not found.")
            return
        }
        let userAccountKey = AccountKey(
            index: -1,
            publicKey: privateKey.publicKey,
            signatureAlgorithm: .ecdsaP256,
            hashAlgorithm: .sha2_256,
            weight: 1000,
            sequenceNumber: 0
        )
        guard let referenceBlock = try client.getLatestBlock(isSealed: true).wait() else {
            XCTFail("getLatestBlock is nil")
            return
        }

        var transaction = try Transaction(
            script: try Utils.getTestData(name: "createAccount.cdc"),
            arguments: [
                userAccountKey.publicKey.cadenceValue,
                userAccountKey.hashAlgorithm.cadenceValue,
                .ufix64(Decimal(userAccountKey.weight)),
            ],
            referenceBlockId: referenceBlock.blockHeader.id,
            gasLimit: 1000,
            proposalKey: Transaction.ProposalKey(
                address: address,
                keyIndex: adminAccountKey.index,
                sequenceNumber: adminAccountKey.sequenceNumber
            ),
            payer: address,
            authorizers: [address]
        )

        try transaction.signEnvelope(address: address, keyIndex: 0, signer: signer)

        // Act
        let identifier = try client.sendTransaction(transaction: transaction).wait()
        debugPrint(identifier.hexString)

        // Assert
        var result: TransactionResult?
        while result?.status != .sealed  {
            result = try client.getTransactionResult(id: identifier).wait()
            sleep(5)
        }
        guard let finalResult = result else {
            XCTFail("result is nil")
            return
        }
        debugPrint(finalResult)
        XCTAssertNil(finalResult.errorMessage)
    }

}
