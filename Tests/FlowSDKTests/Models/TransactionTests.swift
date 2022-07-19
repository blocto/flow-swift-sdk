//
//  TransactionTests.swift
// 
//  Created by Scott on 2022/5/18.
//  Copyright © 2022 portto. All rights reserved.
//

import XCTest
import Crypto
import Cadence
@testable import FlowSDK

final class TransactionTests: XCTestCase {

    func testAddArugment() throws {
        // Arrange
        let transaction = Transaction.makeEmpty()

        // Assert
        XCTAssertTrue(transaction.arguments.isEmpty)
    }

    func testAddSingleArugment() throws {
        // Arrange
        var transaction = Transaction.makeEmpty()
        let argument = Cadence.Value.string("foo")
        try transaction.addArgument(value: argument)

        // Act
        let result = try transaction.getArugment(at: 0)

        // Assert
        XCTAssertEqual(result, argument)
    }

    func testAddMultipleArguments() throws {
        // Arrange
        let argument1 = Cadence.Value.string("foo")
        let argument2 = Cadence.Value.int(42)
        var transaction = Transaction.makeEmpty()

        // Act
        try transaction.addArgument(value: argument1)
        try transaction.addArgument(value: argument2)

        // Assert
        let result1 = try transaction.getArugment(at: 0)
        let result2 = try transaction.getArugment(at: 1)
        XCTAssertEqual(result1, argument1)
        XCTAssertEqual(result2, argument2)
    }

    func testAddRawArgument() throws {
        // Arrange
        let argument = Cadence.Value.string("foo")
        let encodedArgument = try JSONEncoder().encode(argument)
        var transaction = Transaction.makeEmpty()

        // Act
        transaction.addRawArgument(encodedArgument)

        // Assert
        let result = try transaction.getArugment(at: 0)
        XCTAssertEqual(result, argument)
    }

    func testAddMultipleRawArugments() throws {
        // Arrange
        let argument1 = Cadence.Value.string("foo")
        let argument2 = Cadence.Value.int(42)
        let encodedArgument1 = try JSONEncoder().encode(argument1)
        let encodedArgument2 = try JSONEncoder().encode(argument2)
        var transaction = Transaction.makeEmpty()

        // Act
        transaction.addRawArguments([encodedArgument1, encodedArgument2])

        // Assert
        let result1 = try transaction.getArugment(at: 0)
        let result2 = try transaction.getArugment(at: 1)
        XCTAssertEqual(result1, argument1)
        XCTAssertEqual(result2, argument2)
    }

    func testInvalidArugment() throws {
        // Arrange
        var transaction = Transaction.makeEmpty()

        // Act
        transaction.addRawArgument(Data([1, 2, 3]))

        // Assert
        XCTAssertThrowsError(try transaction.getArugment(at: 0))
    }

    func testSetProposalKey() throws {
        // Arrange
        let address = Address(hexString: "0xe083dd0bd08e4acc")
        let keyIndex = 7
        let sequenceNumber: UInt64 = 42
        var transaction = Transaction.makeEmpty()

        // Act
        transaction.setProposalKey(
            address: address,
            keyIndex: keyIndex,
            sequenceNumber: sequenceNumber)

        // Assert
        XCTAssertEqual(transaction.proposalKey.address, address)
    }

    func testAddAuthorizer() throws {
        // Arrange
        let address1 = Address(hexString: "0xe083dd0bd08e4acc")
        let address2 = Address(hexString: "0xcb2d04fc89307107")
        var transaction = Transaction.makeEmpty()

        // Act
        transaction.addAuthorizer(address: address1)

        // Assert
        XCTAssertEqual(transaction.authorizers[0], address1)

        // Act
        transaction.addAuthorizer(address: address2)

        // Assert
        XCTAssertEqual(transaction.authorizers.count, 2)
        XCTAssertEqual(transaction.authorizers[0], address1)
        XCTAssertEqual(transaction.authorizers[1], address2)
        XCTAssertNotEqual(transaction.authorizers[0], transaction.authorizers[1])
    }

    func testAddPayloadSignatureWithInvalidSigner() throws {
        // Arrange
        var transaction = Transaction.makeEmpty()
        let address = Address(hexString: "0xe083dd0bd08e4acc")

        // Act
        transaction.addPayloadSignature(
            address: address,
            keyIndex: 7,
            signature: Data(count: 42))

        // Assert
        XCTAssertEqual(transaction.payloadSignatures.count, 1)
        XCTAssertEqual(transaction.payloadSignatures[0].signerIndex, -1)
    }

    func testAddPayloadSignatureWithValidSigner() throws {
        // Arrange
        let address1 = Address(hexString: "0xe083dd0bd08e4acc")
        let address2 = Address(hexString: "0xcb2d04fc89307107")
        var transaction = Transaction.makeEmpty()
        let keyIndex = 7
        let signature = Data(count: 42)
        transaction.addAuthorizer(address: address1)
        transaction.addAuthorizer(address: address2)

        // Act
        transaction.addPayloadSignature(
            address: address1,
            keyIndex: keyIndex,
            signature: signature)
        transaction.addPayloadSignature(
            address: address2,
            keyIndex: keyIndex,
            signature: signature)

        // Assert
        XCTAssertEqual(transaction.payloadSignatures.count, 2)
        XCTAssertEqual(transaction.payloadSignatures[0].signerIndex, 0)
        XCTAssertEqual(transaction.payloadSignatures[0].address, address1)
        XCTAssertEqual(transaction.payloadSignatures[0].keyIndex, keyIndex)
        XCTAssertEqual(transaction.payloadSignatures[0].signature, signature)
        XCTAssertEqual(transaction.payloadSignatures[1].signerIndex, 1)
        XCTAssertEqual(transaction.payloadSignatures[1].address, address2)
        XCTAssertEqual(transaction.payloadSignatures[1].keyIndex, keyIndex)
        XCTAssertEqual(transaction.payloadSignatures[1].signature, signature)
    }

    func testAddPayloadSignatureWithDuplicateSigners() throws {
        // Arrange
        let address1 = Address(hexString: "0xe083dd0bd08e4acc")
        let address2 = Address(hexString: "0xcb2d04fc89307107")
        let keyIndex = 7
        let signature = Data(count: 42)
        var transaction = Transaction.makeEmpty()
        transaction.setProposalKey(
            address: address1,
            keyIndex: keyIndex,
            sequenceNumber: 42)
        transaction.addAuthorizer(address: address2)
        transaction.addAuthorizer(address: address1)

        // Act
        transaction.addPayloadSignature(
            address: address2,
            keyIndex: keyIndex,
            signature: signature)
        transaction.addPayloadSignature(
            address: address1,
            keyIndex: keyIndex,
            signature: signature)

        // Assert
        XCTAssertEqual(transaction.payloadSignatures.count, 2)
        XCTAssertEqual(transaction.payloadSignatures[0].signerIndex, 0)
        XCTAssertEqual(transaction.payloadSignatures[0].address, address1)
        XCTAssertEqual(transaction.payloadSignatures[0].keyIndex, keyIndex)
        XCTAssertEqual(transaction.payloadSignatures[0].signature, signature)
        XCTAssertEqual(transaction.payloadSignatures[1].signerIndex, 1)
        XCTAssertEqual(transaction.payloadSignatures[1].address, address2)
        XCTAssertEqual(transaction.payloadSignatures[1].keyIndex, keyIndex)
        XCTAssertEqual(transaction.payloadSignatures[1].signature, signature)
    }

    func testAddPayloadSignatureWithMultipleSignatures() throws {
        // Arrange
        let address = Address(hexString: "0xe083dd0bd08e4acc")
        let keyIndex1 = 7
        let signature1 = Data(count: 42)
        let keyIndex2 = 8
        let signature2 = Data(count: 42)
        var transaction = Transaction.makeEmpty()
        transaction.addAuthorizer(address: address)

        // Act
        transaction.addPayloadSignature(
            address: address,
            keyIndex: keyIndex2,
            signature: signature2)
        transaction.addPayloadSignature(
            address: address,
            keyIndex: keyIndex1,
            signature: signature1)

        // Assert
        XCTAssertEqual(transaction.payloadSignatures.count, 2)
        XCTAssertEqual(transaction.payloadSignatures[0].signerIndex, 0)
        XCTAssertEqual(transaction.payloadSignatures[0].address, address)
        XCTAssertEqual(transaction.payloadSignatures[0].keyIndex, keyIndex1)
        XCTAssertEqual(transaction.payloadSignatures[0].signature, signature1)
        XCTAssertEqual(transaction.payloadSignatures[1].signerIndex, 0)
        XCTAssertEqual(transaction.payloadSignatures[1].address, address)
        XCTAssertEqual(transaction.payloadSignatures[1].keyIndex, keyIndex2)
        XCTAssertEqual(transaction.payloadSignatures[1].signature, signature2)
    }

    func testAddEnvelopeSignatureWithInvalidSignre() throws {
        // Arrange
        var transaction = Transaction.makeEmpty()
        let address = Address(hexString: "0xe083dd0bd08e4acc")

        // Act
        transaction.addEnvelopeSignature(
            address: address,
            keyIndex: 7,
            signature: Data(count: 42))

        // Assert
        XCTAssertEqual(transaction.envelopeSignatures.count, 1)
        XCTAssertEqual(transaction.envelopeSignatures[0].signerIndex, -1)
    }

    func testAddEnvelopeSignatureWithValidSigner() throws {
        // Arrange
        let address = Address(hexString: "0xe083dd0bd08e4acc")
        var transaction = Transaction.makeEmpty()
        let keyIndex = 7
        let signature = Data(count: 42)
        transaction.setPayer(address: address)

        // Act
        transaction.addEnvelopeSignature(
            address: address,
            keyIndex: keyIndex,
            signature: signature)

        // Assert
        XCTAssertEqual(transaction.envelopeSignatures.count, 1)
        XCTAssertEqual(transaction.envelopeSignatures[0].signerIndex, 0)
        XCTAssertEqual(transaction.envelopeSignatures[0].address, address)
        XCTAssertEqual(transaction.envelopeSignatures[0].keyIndex, keyIndex)
        XCTAssertEqual(transaction.envelopeSignatures[0].signature, signature)
    }

    func testAddEnvelopeSignatureWithMultipleSignatuers() throws {
        // Arrange
        let address = Address(hexString: "0xe083dd0bd08e4acc")
        let keyIndex1 = 7
        let signature1 = Data(count: 42)
        let keyIndex2 = 8
        let signature2 = Data(count: 42)
        var transaction = Transaction.makeEmpty()
        transaction.addAuthorizer(address: address)

        // Act
        transaction.addEnvelopeSignature(
            address: address,
            keyIndex: keyIndex2,
            signature: signature2)
        transaction.addEnvelopeSignature(
            address: address,
            keyIndex: keyIndex1,
            signature: signature1)

        // Assert
        XCTAssertEqual(transaction.envelopeSignatures.count, 2)
        XCTAssertEqual(transaction.envelopeSignatures[0].signerIndex, 0)
        XCTAssertEqual(transaction.envelopeSignatures[0].address, address)
        XCTAssertEqual(transaction.envelopeSignatures[0].keyIndex, keyIndex1)
        XCTAssertEqual(transaction.envelopeSignatures[0].signature, signature1)
        XCTAssertEqual(transaction.envelopeSignatures[1].signerIndex, 0)
        XCTAssertEqual(transaction.envelopeSignatures[1].address, address)
        XCTAssertEqual(transaction.envelopeSignatures[1].keyIndex, keyIndex2)
        XCTAssertEqual(transaction.envelopeSignatures[1].signature, signature2)
    }

    func testAbleToReconstructWithValidSigner() throws {
        // Arrange
        let address1 = Address(hexString: "0xe083dd0bd08e4acc")
        let address2 = Address(hexString: "0xcb2d04fc89307107")
        let keyIndex = 7
        let signature = Data(count: 42)
        var transaction = Transaction.makeEmpty()
        transaction.addAuthorizer(address: address1)
        transaction.setProposalKey(
            address: address2,
            keyIndex: 0,
            sequenceNumber: 0)
        transaction.setPayer(address: address1)

        // Act
        transaction.addPayloadSignature(
            address: address2,
            keyIndex: 0,
            signature: signature)
        transaction.addEnvelopeSignature(
            address: address1,
            keyIndex: keyIndex,
            signature: signature)

        // Assert
        XCTAssertEqual(transaction.envelopeSignatures.count, 1)
        XCTAssertEqual(transaction.payloadSignatures.count, 1)
        XCTAssertEqual(transaction.payloadSignatures[0].signerIndex, 0)
        XCTAssertEqual(transaction.envelopeSignatures[0].signerIndex, 1)
        XCTAssertEqual(transaction.envelopeSignatures[0].address, address1)
        XCTAssertEqual(transaction.envelopeSignatures[0].keyIndex, keyIndex)
        XCTAssertEqual(transaction.envelopeSignatures[0].signature, signature)

        var newTransaction = Transaction.makeEmpty()

        // Act
        newTransaction.addPayloadSignature(
            address: address2,
            keyIndex: 0,
            signature: signature)
        newTransaction.addEnvelopeSignature(
            address: address1,
            keyIndex: keyIndex,
            signature: signature)

        // Assert
        XCTAssertEqual(newTransaction.payloadSignatures[0].signerIndex, -1)
        XCTAssertEqual(newTransaction.envelopeSignatures[0].signerIndex, -1)

        // Act
        newTransaction.addAuthorizer(address: address1)
        newTransaction.setProposalKey(address: address2, keyIndex: 0, sequenceNumber: 0)
        newTransaction.setPayer(address: address1)

        // Assert
        XCTAssertEqual(newTransaction.payloadSignatures[0].signerIndex, 0)
        XCTAssertEqual(newTransaction.envelopeSignatures[0].signerIndex, 1)
        XCTAssertEqual(newTransaction.envelopeSignatures[0].address, address1)
        XCTAssertEqual(newTransaction.envelopeSignatures[0].keyIndex, keyIndex)
        XCTAssertEqual(newTransaction.envelopeSignatures[0].signature, signature)
        XCTAssertEqual(transaction.id, newTransaction.id)
    }

    func testSignatureOrdering() throws {
        // Arrange
        var transaction = Transaction.makeEmpty()
        let proposerAddress = Address(hexString: "0xe083dd0bd08e4acc")
        let proposerKeyIndex = 8
        let proposerSequenceNumber: UInt64 = 42
        let proposerSignature = Data([1, 2, 3])
        let authorizerAddress = Address(hexString: "0xcb2d04fc89307107")
        let authorizerKeyIndex = 0
        let authorizerSignature = Data([4, 5, 6])
        let payerAddress = Address(hexString: "0xa3ccd8d5ce0531ed")
        let payerKeyIndex = 0
        let payerSignature = Data([7, 8, 9])

        // Act
        transaction.setProposalKey(
            address: proposerAddress,
            keyIndex: proposerKeyIndex,
            sequenceNumber: proposerSequenceNumber)
        transaction.addPayloadSignature(
            address: proposerAddress,
            keyIndex: proposerKeyIndex,
            signature: proposerSignature)
        transaction.setPayer(address: payerAddress)
        transaction.addEnvelopeSignature(
            address: payerAddress,
            keyIndex: payerKeyIndex,
            signature: payerSignature)
        transaction.addAuthorizer(address: authorizerAddress)
        transaction.addPayloadSignature(
            address: authorizerAddress,
            keyIndex: authorizerKeyIndex,
            signature: authorizerSignature)

        XCTAssertEqual(transaction.payloadSignatures.count, 2)
        XCTAssertEqual(transaction.payloadSignatures[0].address, proposerAddress)
        XCTAssertEqual(transaction.payloadSignatures[1].address, authorizerAddress)
    }

    // MARK: RLPMessages

    func testRLPMessagesCompleteTransaction() throws {
        // Arrange
        let transaction = Transaction.makeBase()

        // Assert
        XCTAssertEqual(transaction.payloadMessage(), Data(hex: "f872b07472616e73616374696f6e207b2065786563757465207b206c6f67282248656c6c6f2c20576f726c64212229207d207dc0a0f0e4c2f76c58916ec258f246851bea091d14d4247a2fc3e18694461b1816e13b2a880000000000000001040a880000000000000001c9880000000000000001"))
        XCTAssertEqual(transaction.envelopeMessage(), Data(hex: "f899f872b07472616e73616374696f6e207b2065786563757465207b206c6f67282248656c6c6f2c20576f726c64212229207d207dc0a0f0e4c2f76c58916ec258f246851bea091d14d4247a2fc3e18694461b1816e13b2a880000000000000001040a880000000000000001c9880000000000000001e4e38004a0f7225388c1d69d57e6251c9fda50cbbf9e05131e5adb81e5aa0422402f048162"))
    }

    func testRLPMessagesCompleteTransactionWithEnvelopeSignature() throws {
        // Arrange
        var transaction = Transaction.makeBase()
        transaction.addEnvelopeSignature(
            address: Address(hexString: "01"),
            keyIndex: 4,
            signature: Data(hex: "f7225388c1d69d57e6251c9fda50cbbf9e05131e5adb81e5aa0422402f048162"))

        // Assert
        XCTAssertEqual(transaction.payloadMessage(), Data(hex: "f872b07472616e73616374696f6e207b2065786563757465207b206c6f67282248656c6c6f2c20576f726c64212229207d207dc0a0f0e4c2f76c58916ec258f246851bea091d14d4247a2fc3e18694461b1816e13b2a880000000000000001040a880000000000000001c9880000000000000001"))
        XCTAssertEqual(transaction.envelopeMessage(), Data(hex: "f899f872b07472616e73616374696f6e207b2065786563757465207b206c6f67282248656c6c6f2c20576f726c64212229207d207dc0a0f0e4c2f76c58916ec258f246851bea091d14d4247a2fc3e18694461b1816e13b2a880000000000000001040a880000000000000001c9880000000000000001e4e38004a0f7225388c1d69d57e6251c9fda50cbbf9e05131e5adb81e5aa0422402f048162"))
    }

    func testRLPMessagesEmptyScript() throws {
        // Arrange
        var transaction = Transaction.makeBase()
        transaction.script = Data()

        // Assert
        XCTAssertEqual(transaction.payloadMessage(), Data(hex: "f84280c0a0f0e4c2f76c58916ec258f246851bea091d14d4247a2fc3e18694461b1816e13b2a880000000000000001040a880000000000000001c9880000000000000001"))
        XCTAssertEqual(transaction.envelopeMessage(), Data(hex: "f869f84280c0a0f0e4c2f76c58916ec258f246851bea091d14d4247a2fc3e18694461b1816e13b2a880000000000000001040a880000000000000001c9880000000000000001e4e38004a0f7225388c1d69d57e6251c9fda50cbbf9e05131e5adb81e5aa0422402f048162"))
    }

    func testRLPMessagesEmptyReferenceBlock() throws {
        // Arrange
        var transaction = Transaction.makeBase()
        transaction.referenceBlockId = .empty

        // Assert
        XCTAssertEqual(transaction.payloadMessage(), Data(hex: "f872b07472616e73616374696f6e207b2065786563757465207b206c6f67282248656c6c6f2c20576f726c64212229207d207dc0a000000000000000000000000000000000000000000000000000000000000000002a880000000000000001040a880000000000000001c9880000000000000001"))
        XCTAssertEqual(transaction.envelopeMessage(), Data(hex: "f899f872b07472616e73616374696f6e207b2065786563757465207b206c6f67282248656c6c6f2c20576f726c64212229207d207dc0a000000000000000000000000000000000000000000000000000000000000000002a880000000000000001040a880000000000000001c9880000000000000001e4e38004a0f7225388c1d69d57e6251c9fda50cbbf9e05131e5adb81e5aa0422402f048162"))
    }

    func testRLPMessagesZeroGasLimit() throws {
        // Arrange
        var transaction = Transaction.makeBase()
        transaction.gasLimit = 0

        // Assert
        XCTAssertEqual(transaction.payloadMessage(), Data(hex: "f872b07472616e73616374696f6e207b2065786563757465207b206c6f67282248656c6c6f2c20576f726c64212229207d207dc0a0f0e4c2f76c58916ec258f246851bea091d14d4247a2fc3e18694461b1816e13b80880000000000000001040a880000000000000001c9880000000000000001"))
        XCTAssertEqual(transaction.envelopeMessage(), Data(hex: "f899f872b07472616e73616374696f6e207b2065786563757465207b206c6f67282248656c6c6f2c20576f726c64212229207d207dc0a0f0e4c2f76c58916ec258f246851bea091d14d4247a2fc3e18694461b1816e13b80880000000000000001040a880000000000000001c9880000000000000001e4e38004a0f7225388c1d69d57e6251c9fda50cbbf9e05131e5adb81e5aa0422402f048162"))
    }

    func testRLPMessagesEmptyProposalKeyId() throws {
        // Arrange
        var transaction = Transaction.makeBase()
        transaction.setProposalKey(
            address: Address(hexString: "01"),
            keyIndex: 0,
            sequenceNumber: 10)

        // Assert
        XCTAssertEqual(transaction.payloadMessage(), Data(hex: "f872b07472616e73616374696f6e207b2065786563757465207b206c6f67282248656c6c6f2c20576f726c64212229207d207dc0a0f0e4c2f76c58916ec258f246851bea091d14d4247a2fc3e18694461b1816e13b2a880000000000000001800a880000000000000001c9880000000000000001"))
        XCTAssertEqual(transaction.envelopeMessage(), Data(hex: "f899f872b07472616e73616374696f6e207b2065786563757465207b206c6f67282248656c6c6f2c20576f726c64212229207d207dc0a0f0e4c2f76c58916ec258f246851bea091d14d4247a2fc3e18694461b1816e13b2a880000000000000001800a880000000000000001c9880000000000000001e4e38004a0f7225388c1d69d57e6251c9fda50cbbf9e05131e5adb81e5aa0422402f048162"))
    }

    func testRLPMessagesEmptySequenceNumber() throws {
        // Arrange
        var transaction = Transaction.makeBase()
        transaction.setProposalKey(
            address: Address(hexString: "01"),
            keyIndex: 4,
            sequenceNumber: 0)

        // Assert
        XCTAssertEqual(transaction.payloadMessage(), Data(hex: "f872b07472616e73616374696f6e207b2065786563757465207b206c6f67282248656c6c6f2c20576f726c64212229207d207dc0a0f0e4c2f76c58916ec258f246851bea091d14d4247a2fc3e18694461b1816e13b2a8800000000000000010480880000000000000001c9880000000000000001"))
        XCTAssertEqual(transaction.envelopeMessage(), Data(hex: "f899f872b07472616e73616374696f6e207b2065786563757465207b206c6f67282248656c6c6f2c20576f726c64212229207d207dc0a0f0e4c2f76c58916ec258f246851bea091d14d4247a2fc3e18694461b1816e13b2a8800000000000000010480880000000000000001c9880000000000000001e4e38004a0f7225388c1d69d57e6251c9fda50cbbf9e05131e5adb81e5aa0422402f048162"))
    }

    func testRLPMessagesMultipleAuthorizers() throws {
        // Arrange
        var transaction = Transaction.makeBase()
        transaction.addAuthorizer(address: Address(hexString: "02"))

        // Assert
        XCTAssertEqual(transaction.payloadMessage(), Data(hex: "f87bb07472616e73616374696f6e207b2065786563757465207b206c6f67282248656c6c6f2c20576f726c64212229207d207dc0a0f0e4c2f76c58916ec258f246851bea091d14d4247a2fc3e18694461b1816e13b2a880000000000000001040a880000000000000001d2880000000000000001880000000000000002"))
        XCTAssertEqual(transaction.envelopeMessage(), Data(hex: "f8a2f87bb07472616e73616374696f6e207b2065786563757465207b206c6f67282248656c6c6f2c20576f726c64212229207d207dc0a0f0e4c2f76c58916ec258f246851bea091d14d4247a2fc3e18694461b1816e13b2a880000000000000001040a880000000000000001d2880000000000000001880000000000000002e4e38004a0f7225388c1d69d57e6251c9fda50cbbf9e05131e5adb81e5aa0422402f048162"))
    }

    func testRLPMessagesSingleArgument() throws {
        // Arrange
        var transaction = Transaction.makeBase()
        transaction.addRawArgument(try JSONEncoder().encode(Cadence.Value.string("foo")))

        // Assert
        XCTAssertEqual(transaction.payloadMessage(), Data(hex: "f892b07472616e73616374696f6e207b2065786563757465207b206c6f67282248656c6c6f2c20576f726c64212229207d207de09f7b2274797065223a22537472696e67222c2276616c7565223a22666f6f227da0f0e4c2f76c58916ec258f246851bea091d14d4247a2fc3e18694461b1816e13b2a880000000000000001040a880000000000000001c9880000000000000001"))
        XCTAssertEqual(transaction.envelopeMessage(), Data(hex: "f8b9f892b07472616e73616374696f6e207b2065786563757465207b206c6f67282248656c6c6f2c20576f726c64212229207d207de09f7b2274797065223a22537472696e67222c2276616c7565223a22666f6f227da0f0e4c2f76c58916ec258f246851bea091d14d4247a2fc3e18694461b1816e13b2a880000000000000001040a880000000000000001c9880000000000000001e4e38004a0f7225388c1d69d57e6251c9fda50cbbf9e05131e5adb81e5aa0422402f048162"))
    }

    func testRLPMessagesMultipleArguments() throws {
        // Arrange
        var transaction = Transaction.makeBase()
        transaction.addRawArgument(try JSONEncoder().encode(Cadence.Value.string("foo")))
        transaction.addRawArgument(try JSONEncoder().encode(Cadence.Value.int(42)))

        // Assert
        XCTAssertEqual(transaction.payloadMessage(), Data(hex: "f8afb07472616e73616374696f6e207b2065786563757465207b206c6f67282248656c6c6f2c20576f726c64212229207d207df83c9f7b2274797065223a22537472696e67222c2276616c7565223a22666f6f227d9b7b2274797065223a22496e74222c2276616c7565223a223432227da0f0e4c2f76c58916ec258f246851bea091d14d4247a2fc3e18694461b1816e13b2a880000000000000001040a880000000000000001c9880000000000000001"))
        XCTAssertEqual(transaction.envelopeMessage(), Data(hex: "f8d6f8afb07472616e73616374696f6e207b2065786563757465207b206c6f67282248656c6c6f2c20576f726c64212229207d207df83c9f7b2274797065223a22537472696e67222c2276616c7565223a22666f6f227d9b7b2274797065223a22496e74222c2276616c7565223a223432227da0f0e4c2f76c58916ec258f246851bea091d14d4247a2fc3e18694461b1816e13b2a880000000000000001040a880000000000000001c9880000000000000001e4e38004a0f7225388c1d69d57e6251c9fda50cbbf9e05131e5adb81e5aa0422402f048162"))
    }

}

private extension Transaction {

    static func makeEmpty() -> Transaction {
        return Transaction(
            script: Data(),
            referenceBlockId: Identifier(data: Data()),
            proposalKey: .init(
                address: Address(data: Data()),
                keyIndex: 0,
                sequenceNumber: 0),
            payer: Address(data: Data()))
    }

    static func makeBase() -> Transaction {
        var transaction = Transaction(
            script: #"transaction { execute { log("Hello, World!") } }"#.data(using: .utf8)!,
            referenceBlockId: Identifier(hexString: "f0e4c2f76c58916ec258f246851bea091d14d4247a2fc3e18694461b1816e13b"),
            gasLimit: 42,
            proposalKey: .init(
                address: Address(hexString: "01"),
                keyIndex: 4,
                sequenceNumber: 10),
            payer: Address(hexString: "01"),
            authorizers: [Address(hexString: "01")])
        transaction.addPayloadSignature(
            address: Address(hexString: "01"),
            keyIndex: 4,
            signature: Data(hex: "f7225388c1d69d57e6251c9fda50cbbf9e05131e5adb81e5aa0422402f048162"))
        return transaction
    }

}
