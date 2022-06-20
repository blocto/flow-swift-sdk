//
//  TransactionTests.swift
//
//  Created by Scott on 2022/5/18.
//  Copyright © 2022 portto. All rights reserved.
//

@testable import SDK
import Crypto
import Cadence
import XCTest

final class TransactionTests: XCTestCase {

    let host = "access.devnet.nodes.onflow.org"
    let port = 9000

    lazy var client: Client = Client(host: host, port: port)

    lazy var addressA = Address(hexString: "0xc6de0d94160377cd")
    lazy var rawKeyA = Data(hex: "c9c0f04adddf7674d265c395de300a65a777d3ec412bba5bfdfd12cffbbb78d9")
    lazy var privateKeyA = try! PrivateKey(data: rawKeyA, signatureAlgorithm: .ecdsaP256)

    lazy var addressB = Address(hexString: "0x10711015c370a95c")
    lazy var rawKeyB = Data(hex: "38ebd09b83e221e406b176044a65350333b3a5280ed3f67227bd80d55ac91a0f")
    lazy var privateKeyB = try! PrivateKey(data: rawKeyB, signatureAlgorithm: .ecdsaP256)

    lazy var addressC = Address(hexString: "0xe242ccfb4b8ea3e2")
    lazy var rawKeyC = Data(hex: "1eb79c40023143821983dc79b4e639789ea42452e904fda719f5677a1f144208")
    lazy var privateKeyC = try! PrivateKey(data: rawKeyC, signatureAlgorithm: .ecdsaP256)

    func testFlowPing() throws {
        XCTAssertNoThrow(try client.ping().wait())
    }

    func testFlowFee() throws {
        let result = try client.executeScriptAtLatestBlock(
            script: Data("""
            import FlowFees from 0x912d5440f7e3769e

            pub fun main(): FlowFees.FeeParameters {
                return FlowFees.getFeeParameters()
            }
            """.utf8),
            arguments: []
        ).wait()
        print(result)
    }

    func testNetworkParameters() throws {
        let result = try client.getNetworkParameters().wait()
        XCTAssertEqual(result, "flow-testnet")
    }

    func testCanCreateAccount() throws {
        // Example in Testnet

        // Admin key
        let address = addressC
        let signer = InMemorySigner(privateKey: privateKeyC, hashAlgorithm: .sha2_256)

        // User publick key

        guard let adminAccount = try client.getAccountAtLatestBlock(address: addressC).wait() else {
            XCTFail("adminAccount not found.")
            return
        }

        let selectedAccountKey = adminAccount.keys.first { $0.publicKey == privateKeyC.publicKey }
        guard let adminAccountKey = selectedAccountKey else {
            XCTFail("adminAccountKey not found.")
            return
        }

        let userAccountKey = AccountKey(
            index: -1,
            publicKey: privateKeyA.publicKey,
            signatureAlgorithm: .ecdsaP256,
            hashAlgorithm: .sha2_256,
            weight: 1000,
            sequenceNumber: 0
        )

        guard let referenceBlock = try client.getLatestBlock(isSealed: true).wait() else {
            XCTFail()
            return
        }
        var transaction = try Transaction(
            script: Data("""
            import Crypto
            transaction(publicKey: String, signatureAlgorithm: UInt8, hashAlgorithm: UInt8, weight: UFix64) {
                prepare(signer: AuthAccount) {
                    let key = PublicKey(
                        publicKey: publicKey.decodeHex(),
                        signatureAlgorithm: SignatureAlgorithm(rawValue: signatureAlgorithm)!
                    )
                    let account = AuthAccount(payer: signer)
                    account.keys.add(
                        publicKey: key,
                        hashAlgorithm: HashAlgorithm(rawValue: hashAlgorithm)!,
                        weight: weight
                    )
                }
            }
            """.utf8),
            arguments: [
                .string(userAccountKey.publicKey.hexString),
                .uint8(userAccountKey.signatureAlgorithm.cadenceValue),
                .uint8(UInt8(userAccountKey.hashAlgorithm!.rawValue)),
                .ufix64(Decimal(userAccountKey.weight)),
            ],
            referenceBlockId: referenceBlock.blockHeader.id,
            gasLimit: 1000,
            proposalKey: Transaction.ProposalKey(
                address: addressC,
                keyIndex: adminAccountKey.index,
                sequenceNumber: adminAccountKey.sequenceNumber
            ),
            payer: address,
            authorizers: [addressC]
        )

        try transaction.signEnvelope(address: addressC, keyIndex: 0, signer: signer)

        let identifier = try client.sendTransaction(transaction: transaction).wait()
        print("txid --> \(identifier.hexString)")

        var result: TransactionResult?
        while result?.status != .sealed  {
            result = try client.getTransactionResult(id: identifier).wait()
            sleep(3)
        }
        guard let finalResult = result else {
            XCTFail("result is nil")
            return
        }
        print(result)
        XCTAssertNil(finalResult.errorMessage)
    }

}
