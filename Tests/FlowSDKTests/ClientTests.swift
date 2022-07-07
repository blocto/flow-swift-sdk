//
//  ClientTests.swift
//
//  Created by Scott on 2022/5/18.
//  Copyright © 2022 portto. All rights reserved.
//

import XCTest
import SwiftProtobuf
import Protobuf
import Cadence
import NIO
import GRPC
import Crypto
@testable import FlowSDK

final class ClientTests: XCTestCase {

    private var accessAPIClient: Flow_Access_AccessAPITestClient!
    private var sut: Client!

    override func setUpWithError() throws {
        accessAPIClient = Flow_Access_AccessAPITestClient()
        sut = Client(
            eventLoopGroup: MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount),
            accessAPIClient: accessAPIClient)
    }

    override func tearDownWithError() throws {
        sut = nil
        accessAPIClient = nil
    }

    func testPing() throws {
        // Arrange
        accessAPIClient.enqueuePingResponse(Flow_Access_PingResponse())

        // Act
        try sut.ping().wait()

        // Assert
        XCTAssertFalse(accessAPIClient.hasPingResponsesRemaining)
    }

    func testGetLatestBlockHeader() throws {
        // Arrange
        let id = Data(hex: "e06759c55e126e5c96ca5427d37fca397311b09bb16fe89ccfe288f950ed2831")
        let parentId = Data(hex: "9914002f7b3c4fb6fc053f70e499d216dbe6fc3418254b91dd45018664b66544")
        let height: UInt64 = 68571606
        let timestamp = Date().timeIntervalSince1970
        let blockHeader = Flow_Entities_BlockHeader.with {
            $0.id = id
            $0.parentID = parentId
            $0.height = height
            $0.timestamp = .init(timeIntervalSince1970: timestamp)
        }
        let response = Flow_Access_BlockHeaderResponse.with {
            $0.block = blockHeader
        }
        accessAPIClient.enqueueGetLatestBlockHeaderResponse(response)

        // Act
        let result = try sut.getLatestBlockHeader(isSealed: true).wait()

        // Assert
        XCTAssertFalse(accessAPIClient.hasGetLatestBlockHeaderResponsesRemaining)
        let expected = BlockHeader(
            id: Identifier(data: id),
            parentId: Identifier(data: parentId),
            height: height,
            timestamp: Date(timeIntervalSince1970: timestamp))
        XCTAssertEqual(result, expected)
    }

    func testGetBlockHeaderById() throws {
        // Arrange
        let id = Data(hex: "e06759c55e126e5c96ca5427d37fca397311b09bb16fe89ccfe288f950ed2831")
        let parentId = Data(hex: "9914002f7b3c4fb6fc053f70e499d216dbe6fc3418254b91dd45018664b66544")
        let height: UInt64 = 68571606
        let timestamp = Date().timeIntervalSince1970
        let blockHeader = Flow_Entities_BlockHeader.with {
            $0.id = id
            $0.parentID = parentId
            $0.height = height
            $0.timestamp = .init(timeIntervalSince1970: timestamp)
        }
        let response = Flow_Access_BlockHeaderResponse.with {
            $0.block = blockHeader
        }
        accessAPIClient.enqueueGetBlockHeaderByIDResponse(response)

        // Act
        let result = try sut.getBlockHeaderById(blockId: Identifier(data: id)).wait()

        // Assert
        XCTAssertFalse(accessAPIClient.hasGetBlockHeaderByIDResponsesRemaining)
        let expected = BlockHeader(
            id: Identifier(data: id),
            parentId: Identifier(data: parentId),
            height: height,
            timestamp: Date(timeIntervalSince1970: timestamp))
        XCTAssertEqual(result, expected)
    }

    func testGetBlockHeaderByHeight() throws {
        // Arrange
        let id = Data(hex: "e06759c55e126e5c96ca5427d37fca397311b09bb16fe89ccfe288f950ed2831")
        let parentId = Data(hex: "9914002f7b3c4fb6fc053f70e499d216dbe6fc3418254b91dd45018664b66544")
        let height: UInt64 = 68571606
        let timestamp = Date().timeIntervalSince1970
        let blockHeader = Flow_Entities_BlockHeader.with {
            $0.id = id
            $0.parentID = parentId
            $0.height = height
            $0.timestamp = .init(timeIntervalSince1970: timestamp)
        }
        let response = Flow_Access_BlockHeaderResponse.with {
            $0.block = blockHeader
        }
        accessAPIClient.enqueueGetBlockHeaderByHeightResponse(response)

        // Act
        let result = try sut.getBlockHeaderByHeight(height: height).wait()

        // Assert
        XCTAssertFalse(accessAPIClient.hasGetBlockHeaderByHeightResponsesRemaining)
        let expected = BlockHeader(
            id: Identifier(data: id),
            parentId: Identifier(data: parentId),
            height: height,
            timestamp: Date(timeIntervalSince1970: timestamp))
        XCTAssertEqual(result, expected)
    }

    func testGetLatestBlock() throws {
        // Arrange
        let id = Data(hex: "c5110d10e126e3b1217f4de2903ffbb9a7791c8ad29d44ebb68f713afb084530")
        let parentId = Data(hex: "432ff858cb053b0db1252e0c0b50ac4d4ba9fbff5617fcea8bee64bf086406f9")
        let height: UInt64 = 68593232
        let timestamp = Date().timeIntervalSince1970
        let collectionId = Data(hex: "9d850ea09245588431a0ab29c890c6046523818024c614238a89e74d60c5cdfc")
        let blockId = Data(hex: "5a7144803f1978b38d6b1d55cdf1c9e48363e4910d0d3b3c59dc8a09ba05f2a5")
        let executionReceiptId = Data(hex: "e33c3b550c089ba9b21be2b6df9cf03de67120043e36c42633248fe7b2349bb7")
        let block = Flow_Entities_Block.with {
            $0.id = id
            $0.parentID = parentId
            $0.height = height
            $0.timestamp = .init(timeIntervalSince1970: timestamp)
            $0.collectionGuarantees = [
                .with { $0.collectionID = collectionId },
                .with { $0.collectionID = collectionId },
            ]
            $0.blockSeals = [.with {
                $0.blockID = blockId
                $0.executionReceiptID = executionReceiptId
            }]
        }
        let response = Flow_Access_BlockResponse.with {
            $0.block = block
        }
        accessAPIClient.enqueueGetLatestBlockResponse(response)

        // Act
        let result = try sut.getLatestBlock(isSealed: true).wait()

        // Assert
        XCTAssertFalse(accessAPIClient.hasGetLatestBlockResponsesRemaining)
        let expected = Block(
            blockHeader: BlockHeader(
                id: Identifier(data: id),
                parentId: Identifier(data: parentId),
                height: height,
                timestamp: Date(timeIntervalSince1970: timestamp)),
            blockPayload: BlockPayload(
                collectionGuarantees: [
                    CollectionGuarantee(collectionId: Identifier(data: collectionId)),
                    CollectionGuarantee(collectionId: Identifier(data: collectionId))
                ],
                seals: [
                    BlockSeal(
                        blockID: Identifier(data: blockId),
                        executionReceiptID: Identifier(data: executionReceiptId))
                ]))
        XCTAssertEqual(result, expected)
    }

    func testGetBlockByID() throws {
        // Arrange
        let id = Data(hex: "c5110d10e126e3b1217f4de2903ffbb9a7791c8ad29d44ebb68f713afb084530")
        let parentId = Data(hex: "432ff858cb053b0db1252e0c0b50ac4d4ba9fbff5617fcea8bee64bf086406f9")
        let height: UInt64 = 68593232
        let timestamp = Date().timeIntervalSince1970
        let collectionId = Data(hex: "9d850ea09245588431a0ab29c890c6046523818024c614238a89e74d60c5cdfc")
        let blockId = Data(hex: "5a7144803f1978b38d6b1d55cdf1c9e48363e4910d0d3b3c59dc8a09ba05f2a5")
        let executionReceiptId = Data(hex: "e33c3b550c089ba9b21be2b6df9cf03de67120043e36c42633248fe7b2349bb7")
        let block = Flow_Entities_Block.with {
            $0.id = id
            $0.parentID = parentId
            $0.height = height
            $0.timestamp = .init(timeIntervalSince1970: timestamp)
            $0.collectionGuarantees = [
                .with { $0.collectionID = collectionId },
                .with { $0.collectionID = collectionId },
            ]
            $0.blockSeals = [.with {
                $0.blockID = blockId
                $0.executionReceiptID = executionReceiptId
            }]
        }
        let response = Flow_Access_BlockResponse.with {
            $0.block = block
        }
        accessAPIClient.enqueueGetBlockByIDResponse(response)

        // Act
        let result = try sut.getBlockByID(blockId: Identifier(data: id)).wait()

        // Assert
        XCTAssertFalse(accessAPIClient.hasGetBlockByIDResponsesRemaining)
        let expected = Block(
            blockHeader: BlockHeader(
                id: Identifier(data: id),
                parentId: Identifier(data: parentId),
                height: height,
                timestamp: Date(timeIntervalSince1970: timestamp)),
            blockPayload: BlockPayload(
                collectionGuarantees: [
                    CollectionGuarantee(collectionId: Identifier(data: collectionId)),
                    CollectionGuarantee(collectionId: Identifier(data: collectionId))
                ],
                seals: [
                    BlockSeal(
                        blockID: Identifier(data: blockId),
                        executionReceiptID: Identifier(data: executionReceiptId))
                ]))
        XCTAssertEqual(result, expected)
    }

    func testGetBlockByHeight() throws {
        // Arrange
        let id = Data(hex: "c5110d10e126e3b1217f4de2903ffbb9a7791c8ad29d44ebb68f713afb084530")
        let parentId = Data(hex: "432ff858cb053b0db1252e0c0b50ac4d4ba9fbff5617fcea8bee64bf086406f9")
        let height: UInt64 = 68593232
        let timestamp = Date().timeIntervalSince1970
        let collectionId = Data(hex: "9d850ea09245588431a0ab29c890c6046523818024c614238a89e74d60c5cdfc")
        let blockId = Data(hex: "5a7144803f1978b38d6b1d55cdf1c9e48363e4910d0d3b3c59dc8a09ba05f2a5")
        let executionReceiptId = Data(hex: "e33c3b550c089ba9b21be2b6df9cf03de67120043e36c42633248fe7b2349bb7")
        let block = Flow_Entities_Block.with {
            $0.id = id
            $0.parentID = parentId
            $0.height = height
            $0.timestamp = .init(timeIntervalSince1970: timestamp)
            $0.collectionGuarantees = [
                .with { $0.collectionID = collectionId },
                .with { $0.collectionID = collectionId },
            ]
            $0.blockSeals = [.with {
                $0.blockID = blockId
                $0.executionReceiptID = executionReceiptId
            }]
        }
        let response = Flow_Access_BlockResponse.with {
            $0.block = block
        }
        accessAPIClient.enqueueGetBlockByHeightResponse(response)

        // Act
        let result = try sut.getBlockByHeight(height: height).wait()

        // Assert
        XCTAssertFalse(accessAPIClient.hasGetBlockByHeightResponsesRemaining)
        let expected = Block(
            blockHeader: BlockHeader(
                id: Identifier(data: id),
                parentId: Identifier(data: parentId),
                height: height,
                timestamp: Date(timeIntervalSince1970: timestamp)),
            blockPayload: BlockPayload(
                collectionGuarantees: [
                    CollectionGuarantee(collectionId: Identifier(data: collectionId)),
                    CollectionGuarantee(collectionId: Identifier(data: collectionId))
                ],
                seals: [
                    BlockSeal(
                        blockID: Identifier(data: blockId),
                        executionReceiptID: Identifier(data: executionReceiptId))
                ]))
        XCTAssertEqual(result, expected)
    }

    func testGetCollection() throws {
        // Arrange
        let collectionId = Data(hex: "9d850ea09245588431a0ab29c890c6046523818024c614238a89e74d60c5cdfc")
        let transactionId = Data(hex: "8d57be3d506586eec547179b41207ad7b3df2b02775682969ffd1aa233a80c37")
        let transactionIds = [transactionId]
        let collection = Flow_Entities_Collection.with {
            $0.transactionIds = transactionIds
        }
        let response = Flow_Access_CollectionResponse.with {
            $0.collection = collection
        }
        accessAPIClient.enqueueGetCollectionByIDResponse(response)

        // Act
        let result = try sut.getCollection(collectionId: Identifier(data: collectionId)).wait()

        // Assert
        XCTAssertFalse(accessAPIClient.hasGetCollectionByIDResponsesRemaining)
        let expected = Collection(transactionIds: transactionIds.map { Identifier(data: $0) })
        XCTAssertEqual(result, expected)
    }

    func testSendTransaction() throws {
        // Arrange
        let script = Data()
        let referenceBlockId = Identifier(hexString: "e0521151ba45f98ff91b6ccabdddd73a68fd8f72c75beb80e70e99304397aee5")
        let payer = Address(hexString: "0x383bd00f77a585bc")
        let proposalKey = Address(hexString: "0xb4e959600bd0f29e")
        let transaction = try Transaction(
            script: script,
            referenceBlockId: referenceBlockId,
            proposalKey: Transaction.ProposalKey(
                address: proposalKey,
                keyIndex: 0,
                sequenceNumber: 0),
            payer: payer)
        let txId = Identifier(hexString: "e0521151ba45f98ff91b6ccabdddd73a68fd8f72c75beb80e70e99304397aee5")
        let response = Flow_Access_SendTransactionResponse.with {
            $0.id = txId.data
        }
        accessAPIClient.enqueueSendTransactionResponse(response)

        // Act
        let result = try sut.sendTransaction(transaction: transaction)
            .wait()

        // Assert
        XCTAssertFalse(accessAPIClient.hasSendTransactionResponsesRemaining)
        XCTAssertEqual(result, txId)
    }

    func testGetTransaction() throws {
        // Arrange
        let id = Identifier(hexString: "eae8599cdde95a4dabe0595f2a77b607769116a18b107b97dbf78c9397891743")
        let script = Data(hex: "696d706f7274204e6f6e46756e6769626c65546f6b656e2066726f6d203078363331653838616537663164376332300a20202020696d706f7274204d6574616461746156696577732066726f6d203078363331653838616537663164376332300a20202020696d706f7274204d464c506c617965722066726f6d203078363833353634653436393737373838610a20202020696d706f7274204d464c41646d696e2066726f6d203078363833353634653436393737373838610a0a202020202f2a2a0a202020202020202054686973207478206d696e74732061206e657720706c61796572204e465420676976656e2061206365727461696e206e756d626572206f6620706172616d65746572732c0a2020202020202020616e64206465706f73697420697420696e2074686520726563656976657220636f6c6c656374696f6e2e0a202020202a2a2f0a0a202020207472616e73616374696f6e280a202020202020202069643a2055496e7436342c0a2020202020202020736561736f6e3a2055496e7433322c0a2020202020202020666f6c6465724349443a20537472696e672c0a20202020202020206e616d653a20537472696e672c0a20202020202020206e6174696f6e616c69746965733a205b537472696e675d2c0a2020202020202020706f736974696f6e733a205b537472696e675d2c0a2020202020202020707265666572726564466f6f743a20537472696e672c0a202020202020202061676541744d696e743a2055496e7433322c0a20202020202020206865696768743a2055496e7433322c0a20202020202020206f766572616c6c3a2055496e7433322c0a2020202020202020706163653a2055496e7433322c0a202020202020202073686f6f74696e673a2055496e7433322c0a202020202020202070617373696e673a2055496e7433322c0a202020202020202064726962626c696e673a2055496e7433322c0a2020202020202020646566656e73653a2055496e7433322c0a2020202020202020706879736963616c3a2055496e7433322c0a2020202020202020676f616c6b656570696e673a2055496e7433322c0a2020202020202020706f74656e7469616c3a20537472696e672c0a20202020202020206c6f6e6765766974793a20537472696e672c0a2020202020202020726573697374616e63653a2055496e7433322c0a20202020202020207265636569766572416464726573733a20416464726573730a2020202029207b0a20202020202020206c657420706c6179657241646d696e50726f78795265663a20264d464c41646d696e2e41646d696e50726f78790a20202020202020206c65742072656365697665725265663a20267b4e6f6e46756e6769626c65546f6b656e2e436f6c6c656374696f6e5075626c69637d0a0a20202020202020207072657061726528616363743a20417574684163636f756e7429207b0a20202020202020202020202073656c662e706c6179657241646d696e50726f7879526566203d20616363742e626f72726f773c264d464c41646d696e2e41646d696e50726f78793e2866726f6d3a204d464c41646d696e2e41646d696e50726f787953746f726167655061746829203f3f2070616e69632822436f756c64206e6f7420626f72726f772061646d696e2070726f7879207265666572656e636522290a2020202020202020202020206c657420706c61796572436f6c6c656374696f6e436170203d206765744163636f756e7428726563656976657241646472657373292e6765744361706162696c6974793c267b4e6f6e46756e6769626c65546f6b656e2e436f6c6c656374696f6e5075626c69637d3e284d464c506c617965722e436f6c6c656374696f6e5075626c696350617468290a20202020202020202020202073656c662e7265636569766572526566203d20706c61796572436f6c6c656374696f6e4361702e626f72726f772829203f3f2070616e69632822436f756c64206e6f7420626f72726f77207265636569766572207265666572656e636522290a20202020202020207d0a0a202020202020202065786563757465207b0a2020202020202020202020206c657420706c6179657241646d696e436c61696d436170203d2073656c662e706c6179657241646d696e50726f78795265662e676574436c61696d4361706162696c697479286e616d653a2022506c6179657241646d696e436c61696d2229203f3f2070616e69632822506c6179657241646d696e436c61696d206361706162696c697479206e6f7420666f756e6422290a2020202020202020202020206c657420706c6179657241646d696e436c61696d526566203d20706c6179657241646d696e436c61696d4361702e626f72726f773c267b4d464c506c617965722e506c6179657241646d696e436c61696d7d3e2829203f3f2070616e69632822436f756c64206e6f7420626f72726f7720506c6179657241646d696e436c61696d22290a0a2020202020202020202020206c6574206d657461646174613a207b537472696e673a20416e795374727563747d203d207b7d0a2020202020202020202020206d657461646174612e696e73657274286b65793a20226e616d65222c206e616d65290a2020202020202020202020206d657461646174612e696e73657274286b65793a20226f766572616c6c222c206f766572616c6c290a2020202020202020202020206d657461646174612e696e73657274286b65793a20226e6174696f6e616c6974696573222c206e6174696f6e616c6974696573290a2020202020202020202020206d657461646174612e696e73657274286b65793a2022706f736974696f6e73222c20706f736974696f6e73290a2020202020202020202020206d657461646174612e696e73657274286b65793a2022707265666572726564466f6f74222c20707265666572726564466f6f74290a2020202020202020202020206d657461646174612e696e73657274286b65793a202261676541744d696e74222c2061676541744d696e74290a2020202020202020202020206d657461646174612e696e73657274286b65793a2022686569676874222c20686569676874290a2020202020202020202020206d657461646174612e696e73657274286b65793a202270616365222c2070616365290a2020202020202020202020206d657461646174612e696e73657274286b65793a202273686f6f74696e67222c2073686f6f74696e67290a2020202020202020202020206d657461646174612e696e73657274286b65793a202270617373696e67222c2070617373696e67290a2020202020202020202020206d657461646174612e696e73657274286b65793a202264726962626c696e67222c2064726962626c696e67290a2020202020202020202020206d657461646174612e696e73657274286b65793a2022646566656e7365222c20646566656e7365290a2020202020202020202020206d657461646174612e696e73657274286b65793a2022706879736963616c222c20706879736963616c290a2020202020202020202020206d657461646174612e696e73657274286b65793a2022676f616c6b656570696e67222c20676f616c6b656570696e67290a2020202020202020202020206d657461646174612e696e73657274286b65793a2022706f74656e7469616c222c20706f74656e7469616c290a2020202020202020202020206d657461646174612e696e73657274286b65793a20226c6f6e676576697479222c206c6f6e676576697479290a2020202020202020202020206d657461646174612e696e73657274286b65793a2022726573697374616e6365222c20726573697374616e6365290a0a2020202020202020202020206c657420696d616765203d204d6574616461746156696577732e4950465346696c65286369643a20666f6c6465724349442c20706174683a206e696c290a2020202020202020202020206c657420706c617965724e4654203c2d20706c6179657241646d696e436c61696d5265662e6d696e74506c61796572280a2020202020202020202020202020202069643a2069642c0a202020202020202020202020202020206d657461646174613a206d657461646174612c0a20202020202020202020202020202020736561736f6e3a20736561736f6e2c0a20202020202020202020202020202020696d6167653a20696d6167652c0a202020202020202020202020290a20202020202020202020202073656c662e72656365697665725265662e6465706f73697428746f6b656e3a203c2d20706c617965724e4654290a20202020202020207d0a0a2020202020202020706f7374207b0a2020202020202020202020204d464c506c617965722e676574506c61796572446174612869643a2069642920213d206e696c3a2022436f756c64206e6f742066696e6420706c61796572206d6574616461746120696e20706f7374220a20202020202020202020202073656c662e72656365697665725265662e67657449447328292e636f6e7461696e73286964293a2022436f756c64206e6f742066696e6420706c6179657220696e20706f7374220a20202020202020207d0a202020207d")
        let referenceBlockId = Data(hex: "e0521151ba45f98ff91b6ccabdddd73a68fd8f72c75beb80e70e99304397aee5")
        let gasLimit: UInt64 = 9999
        let proposalKeyAddress = Data(hex: "383bd00f77a585bc")
        let proposalKeyId: UInt32 = 29
        let proposalKeySequenceNumber: UInt64 = 13
        let payer = Data(hex: "383bd00f77a585bc")
        let authorizer = Data(hex: "383bd00f77a585bc")
        let payloadSignatureAddress = Data(hex: "383bd00f77a585bc")
        let payloadSignatureKeyId: UInt32 = 29
        let payloadSignatureSignature = Data(hex: "72efdbe59b3e6443e611ff73ab325d57076f049891d24267b92dc2493458cf217c87c25bf71e1fbf6c74d72473805588f30a2afa25a1eeff506796bee6efd347")
        let envelopeSignatureAddress = Data(hex: "383bd00f77a585bc")
        let envelopeSignatureKeyId: UInt32 = 0
        let envelopeSignatureSignature = Data(hex: "f2191edc7223d4ccbde951877f0dd4c797f54b1b47668e737246e9bd87f6bb7bebbecaab13776525151fd440f0c87d8c35bffb4419e878148d18d2780a3b11c7")
        let transaction = Flow_Entities_Transaction.with {
            $0.script = script
            $0.arguments = [
                Data(hex: "7b2274797065223a2255496e743634222c2276616c7565223a2234303134227d"),
                Data(hex: "7b2274797065223a2255496e743332222c2276616c7565223a2231227d"),
                Data(hex: "7b2274797065223a22537472696e67222c2276616c7565223a226d6f636b227d"),
                Data(hex: "7b2274797065223a22537472696e67222c2276616c7565223a22537965642054616861227d"),
                Data(hex: "7b2274797065223a224172726179222c2276616c7565223a5b7b2274797065223a22537472696e67222c2276616c7565223a2253415544495f415241424941227d5d7d"),
                Data(hex: "7b2274797065223a224172726179222c2276616c7565223a5b7b2274797065223a22537472696e67222c2276616c7565223a2243414d227d2c7b2274797065223a22537472696e67222c2276616c7565223a22434d227d5d7d"),
                Data(hex: "7b2274797065223a22537472696e67222c2276616c7565223a225249474854227d"),
                Data(hex: "7b2274797065223a2255496e743332222c2276616c7565223a223139227d"),
                Data(hex: "7b2274797065223a2255496e743332222c2276616c7565223a22313832227d"),
                Data(hex: "7b2274797065223a2255496e743332222c2276616c7565223a223730227d"),
                Data(hex: "7b2274797065223a2255496e743332222c2276616c7565223a223537227d"),
                Data(hex: "7b2274797065223a2255496e743332222c2276616c7565223a223631227d"),
                Data(hex: "7b2274797065223a2255496e743332222c2276616c7565223a223831227d"),
                Data(hex: "7b2274797065223a2255496e743332222c2276616c7565223a223535227d"),
                Data(hex: "7b2274797065223a2255496e743332222c2276616c7565223a223735227d"),
                Data(hex: "7b2274797065223a2255496e743332222c2276616c7565223a223635227d"),
                Data(hex: "7b2274797065223a2255496e743332222c2276616c7565223a2230227d"),
                Data(hex: "7b2274797065223a22537472696e67222c2276616c7565223a22553246736447566b58312f785132454d76384e427a32524e527865784541382f6e4d546b2f6e4d337470303d227d"),
                Data(hex: "7b2274797065223a22537472696e67222c2276616c7565223a22553246736447566b5831393363755559587a5a6b5a775965507558324f585634722b4f464546512b5255343d227d"),
                Data(hex: "7b2274797065223a2255496e743332222c2276616c7565223a223636227d"),
                Data(hex: "7b2274797065223a2241646472657373222c2276616c7565223a22307833383362643030663737613538356263227d")
            ]
            $0.referenceBlockID = referenceBlockId
            $0.gasLimit = gasLimit
            $0.proposalKey = .with {
                $0.address = proposalKeyAddress
                $0.keyID = proposalKeyId
                $0.sequenceNumber = proposalKeySequenceNumber
            }
            $0.payer = payer
            $0.authorizers = [authorizer]
            $0.payloadSignatures = [
                .with {
                    $0.address = payloadSignatureAddress
                    $0.keyID = payloadSignatureKeyId
                    $0.signature = payloadSignatureSignature
                }
            ]
            $0.envelopeSignatures = [
                .with {
                    $0.address = Data(hex: "383bd00f77a585bc")
                    $0.keyID = 0
                    $0.signature = Data(hex: "f2191edc7223d4ccbde951877f0dd4c797f54b1b47668e737246e9bd87f6bb7bebbecaab13776525151fd440f0c87d8c35bffb4419e878148d18d2780a3b11c7")
                }
            ]
        }
        let response = Flow_Access_TransactionResponse.with {
            $0.transaction = transaction
        }
        accessAPIClient.enqueueGetTransactionResponse(response)

        // Act
        let result = try sut.getTransaction(id: id).wait()

        // Assert
        XCTAssertFalse(accessAPIClient.hasGetTransactionResponsesRemaining)
        let expected = try Transaction(
            script: script,
            arguments: [
                .uint64(4014),
                .uint32(1),
                .string("mock"),
                .string("Syed Taha"),
                .array([
                    .string("SAUDI_ARABIA")
                ]),
                .array([
                    .string("CAM"),
                    .string("CM")
                ]),
                .string("RIGHT"),
                .uint32(19),
                .uint32(182),
                .uint32(70),
                .uint32(57),
                .uint32(61),
                .uint32(81),
                .uint32(55),
                .uint32(75),
                .uint32(65),
                .uint32(0),
                .string("U2FsdGVkX1/xQ2EMv8NBz2RNRxexEA8/nMTk/nM3tp0="),
                .string("U2FsdGVkX193cuUYXzZkZwYePuX2OXV4r+OFEFQ+RU4="),
                .uint32(66),
                .address(Address(hexString: "0x383bd00f77a585bc"))
            ],
            referenceBlockId: Identifier(data: referenceBlockId),
            gasLimit: gasLimit,
            proposalKey: .init(
                address: Address(data: proposalKeyAddress),
                keyIndex: Int(proposalKeyId),
                sequenceNumber: proposalKeySequenceNumber),
            payer: Address(data: payer),
            authorizers: [Address(data: authorizer)],
            payloadSignatures: [
                .init(
                    address: Address(data: payloadSignatureAddress),
                    signerIndex: 0,
                    keyIndex: Int(payloadSignatureKeyId),
                    signature: payloadSignatureSignature)
            ],
            envelopeSignatures: [
                .init(
                    address: Address(data: envelopeSignatureAddress),
                    signerIndex: 0,
                    keyIndex: Int(envelopeSignatureKeyId),
                    signature: envelopeSignatureSignature)
            ])
        XCTAssertEqual(result, expected)
    }

    func testGetTransactionResult() throws {
        // Arrange
        let id = Identifier(hexString: "6a2b4c6b3597a508dceb6b2814fb7420e2d911a0371de048a02e0f440825684a")
        let blockId = Data(hex: "1ab89cd3b7d87015c9d5ba2aa47bd96116646f4e6817a4824ae54073c4d18c5d")
        let event1Type = "A.cb2d04fc89307107.JRXToken.TokensWithdrawn"
        let event1Payload = "{\"type\":\"Event\",\"value\":{\"id\":\"A.cb2d04fc89307107.JRXToken.TokensWithdrawn\",\"fields\":[{\"name\":\"amount\",\"value\":{\"type\":\"UFix64\",\"value\":\"60.00000000\"}},{\"name\":\"from\",\"value\":{\"type\":\"Optional\",\"value\":{\"type\":\"Address\",\"value\":\"0xb4e959600bd0f29e\"}}}]}}\n"
        let event2Type = "A.cb2d04fc89307107.JoyridePayments.DebitTransactionCreate"
        let event2Payload = "{\"type\":\"Event\",\"value\":{\"id\":\"A.cb2d04fc89307107.JoyridePayments.DebitTransactionCreate\",\"fields\":[{\"name\":\"playerID\",\"value\":{\"type\":\"String\",\"value\":\"fd55216a-63f7-4fea-934b-f0a8e930ac48\"}},{\"name\":\"txID\",\"value\":{\"type\":\"String\",\"value\":\"prodtestnet_onjoyride.tennischamps_578_tennischamps-fd55216a-63f7-4fea-934b-f0a8e930ac48-1-1654160605-1654160605DEBIT!!jrx!!fd55216a-63f7-4fea-934b-f0a8e930ac48\"}},{\"name\":\"tokenContext\",\"value\":{\"type\":\"String\",\"value\":\"A.cb2d04fc89307107.JRXToken.Vault\"}},{\"name\":\"amount\",\"value\":{\"type\":\"UFix64\",\"value\":\"60.00000000\"}},{\"name\":\"gameID\",\"value\":{\"type\":\"String\",\"value\":\"onjoyride.tennischamps\"}},{\"name\":\"notes\",\"value\":{\"type\":\"String\",\"value\":\"userId = fd55216a-63f7-4fea-934b-f0a8e930ac48,amount = 60.0,transactionId = prodtestnet_onjoyride.tennischamps_578_tennischamps-fd55216a-63f7-4fea-934b-f0a8e930ac48-1-1654160605-1654160605DEBIT,transactionPlatform = JR_GAMES,appId = onjoyride.tennischamps,devicePlatform = iOS,transactionType = DEBIT,description = Contest Entry\"}}]}}\n"
        let event3Type = "A.7e60df042a9c0868.FlowToken.TokensWithdrawn"
        let event3Payload = "{\"type\":\"Event\",\"value\":{\"id\":\"A.7e60df042a9c0868.FlowToken.TokensWithdrawn\",\"fields\":[{\"name\":\"amount\",\"value\":{\"type\":\"UFix64\",\"value\":\"0.00001816\"}},{\"name\":\"from\",\"value\":{\"type\":\"Optional\",\"value\":{\"type\":\"Address\",\"value\":\"0xcb2d04fc89307107\"}}}]}}\n"
        let event4Type = "A.7e60df042a9c0868.FlowToken.TokensDeposited"
        let event4Payload = "{\"type\":\"Event\",\"value\":{\"id\":\"A.7e60df042a9c0868.FlowToken.TokensDeposited\",\"fields\":[{\"name\":\"amount\",\"value\":{\"type\":\"UFix64\",\"value\":\"0.00001816\"}},{\"name\":\"to\",\"value\":{\"type\":\"Optional\",\"value\":{\"type\":\"Address\",\"value\":\"0x912d5440f7e3769e\"}}}]}}\n"
        let event5Type = "A.912d5440f7e3769e.FlowFees.FeesDeducted"
        let event5Payload = "{\"type\":\"Event\",\"value\":{\"id\":\"A.912d5440f7e3769e.FlowFees.FeesDeducted\",\"fields\":[{\"name\":\"amount\",\"value\":{\"type\":\"UFix64\",\"value\":\"0.00001816\"}},{\"name\":\"inclusionEffort\",\"value\":{\"type\":\"UFix64\",\"value\":\"1.00000000\"}},{\"name\":\"executionEffort\",\"value\":{\"type\":\"UFix64\",\"value\":\"0.00000344\"}}]}}\n"

        let response = Flow_Access_TransactionResultResponse.with {
            $0.status = .sealed
            $0.statusCode = 0
            $0.events = [
                .with {
                    $0.type = event1Type
                    $0.transactionID = id.data
                    $0.payload = event1Payload.data(using: .utf8) ?? Data()
                },
                .with {
                    $0.type = event2Type
                    $0.transactionID = id.data
                    $0.payload = event2Payload.data(using: .utf8) ?? Data()
                },
                .with {
                    $0.type = event3Type
                    $0.transactionID = id.data
                    $0.payload = event3Payload.data(using: .utf8) ?? Data()
                },
                .with {
                    $0.type = event4Type
                    $0.transactionID = id.data
                    $0.payload = event4Payload.data(using: .utf8) ?? Data()
                },
                .with {
                    $0.type = event5Type
                    $0.transactionID = id.data
                    $0.payload = event5Payload.data(using: .utf8) ?? Data()
                }
            ]
            $0.blockID = blockId
            $0.transactionID = id.data
        }
        accessAPIClient.enqueueGetTransactionResultResponse(response)

        // Act
        let result = try sut.getTransactionResult(id: id).wait()

        // Assert
        XCTAssertFalse(accessAPIClient.hasGetTransactionResultResponsesRemaining)
        let expected = TransactionResult(
            status: .sealed,
            errorMessage: nil,
            events: [
                Event(
                    type: event1Type,
                    transactionId: id,
                    transactionIndex: 0,
                    eventIndex: 0,
                    value: .init(
                        id: event1Type,
                        fields: [
                            .init(
                                name: "amount",
                                value: .ufix64(Decimal(string: "60")!)),
                            .init(
                                name: "from",
                                value: .optional(.address(Address(hexString: "0xb4e959600bd0f29e"))))
                        ]),
                    payload: event1Payload.data(using: .utf8)!),
                Event(
                    type: event2Type,
                    transactionId: id,
                    transactionIndex: 0,
                    eventIndex: 0,
                    value: .init(
                        id: event2Type,
                        fields: [
                            .init(
                                name: "playerID",
                                value: .string("fd55216a-63f7-4fea-934b-f0a8e930ac48")),
                            .init(
                                name: "txID",
                                value: .string("prodtestnet_onjoyride.tennischamps_578_tennischamps-fd55216a-63f7-4fea-934b-f0a8e930ac48-1-1654160605-1654160605DEBIT!!jrx!!fd55216a-63f7-4fea-934b-f0a8e930ac48")),
                            .init(
                                name: "tokenContext",
                                value: .string("A.cb2d04fc89307107.JRXToken.Vault")),
                            .init(
                                name: "amount",
                                value: .ufix64(Decimal(string: "60")!)),
                            .init(
                                name: "gameID",
                                value: .string("onjoyride.tennischamps")),
                            .init(
                                name: "notes",
                                value: .string("userId = fd55216a-63f7-4fea-934b-f0a8e930ac48,amount = 60.0,transactionId = prodtestnet_onjoyride.tennischamps_578_tennischamps-fd55216a-63f7-4fea-934b-f0a8e930ac48-1-1654160605-1654160605DEBIT,transactionPlatform = JR_GAMES,appId = onjoyride.tennischamps,devicePlatform = iOS,transactionType = DEBIT,description = Contest Entry"))
                        ]),
                    payload: event2Payload.data(using: .utf8)!),
                Event(
                    type: event3Type,
                    transactionId: id,
                    transactionIndex: 0,
                    eventIndex: 0,
                    value: .init(
                        id: event3Type,
                        fields: [
                            .init(
                                name: "amount",
                                value: .ufix64(Decimal(string: "0.00001816")!)),
                            .init(
                                name: "from",
                                value: .optional(.address(Address(hexString: "0xcb2d04fc89307107"))))
                        ]),
                    payload: event3Payload.data(using: .utf8)!),
                Event(
                    type: event4Type,
                    transactionId: id,
                    transactionIndex: 0,
                    eventIndex: 0,
                    value: .init(
                        id: event4Type,
                        fields: [
                            .init(
                                name: "amount",
                                value: .ufix64(Decimal(string: "0.00001816")!)),
                            .init(
                                name: "to",
                                value: .optional(.address(Address(hexString: "0x912d5440f7e3769e"))))
                        ]),
                    payload: event4Payload.data(using: .utf8)!),
                Event(
                    type: event5Type,
                    transactionId: id,
                    transactionIndex: 0,
                    eventIndex: 0,
                    value: .init(
                        id: event5Type,
                        fields: [
                            .init(
                                name: "amount",
                                value: .ufix64(Decimal(string: "0.00001816")!)),
                            .init(
                                name: "inclusionEffort",
                                value: .ufix64(Decimal(string: "1.00000000")!)),
                            .init(
                                name: "executionEffort",
                                value: .ufix64(Decimal(string: "0.00000344")!))
                        ]),
                    payload: event5Payload.data(using: .utf8)!)
            ],
            blockId: Identifier(data: blockId))
        XCTAssertEqual(result, expected)
    }

    func testGetAccountAtLatestBlock() throws {
        // Arrange
        let address = Address(hexString: "0xb83579e611780dd1")
        let balance: UInt64 = 97170635
        let code = Data()
        let publicKeys: [Data] = [
            Data(hex: "d247aa2dae6db06afb364a02b168e19c2f013aaf40dc05da4cfa7242f01fbabe1d24cba0313afb7527d594c374338afdaf5fad440f3d2bc65525fe3694b77669"),
            Data(hex: "2ad0b83541ecf06af6454c0ba5f6113852a6bfde0e11df605c4151397f1935c25d7afd3d99ddc2420dae72ab9d297bd137cd316fab67c686b07de2045753a0a9"),
            Data(hex: "4d806ceb62188a24a59cfc5c5dff9b1bdc056a426876efd16581c2cfbace80edc2657d879eb98de9027bc4b9386c3aecf409f8038db36aa2209b2cb89ee43a7c"),
            Data(hex: "dc24a907e2a162a97f73abb2bc1dc845baa932cb9e8054b6c58270aaf9a19923fd7698ec47b175ed27607c968f6f8fcfe61750a96dc5108497bd09107159df31"),
            Data(hex: "fb2594c830c5c9cd7269121b64e1bc97035aac7b876035231bb8191e1316eb02ee85ec458604896e8ea6f64373a6dc45a6a5e74ba3e6089dec114e51c1377a15"),
            Data(hex: "e8299c0e70f519193d64ef3249aac2431c54977a1a978a4fa3a29cfb9f44564ecf91a69a808a63c7ebd3adf79232f06d392f1583b6ce8b3fb86c945a978b4da3"),
            Data(hex: "24896e3e1a57b9dd6de38b4b6d3bdad6174ebcb949fe19087c7d61abf5f4a7b14afc24aa5b3c97662b5d5859f1180ceba3007d35d6f1605b01d05d3d44d31768")
        ]
        let contracts: [String: Data] = [:]
        let response = Flow_Access_AccountResponse.with {
            $0.account = .with {
                $0.address = address.data
                $0.balance = balance
                $0.code = code
                $0.keys = [
                    .with {
                        $0.index = 0
                        $0.publicKey = publicKeys[0]
                        $0.signAlgo = 3
                        $0.hashAlgo = 3
                        $0.weight = 999
                        $0.sequenceNumber = 11
                    },
                    .with {
                        $0.index = 1
                        $0.publicKey = publicKeys[1]
                        $0.signAlgo = 3
                        $0.hashAlgo = 3
                        $0.weight = 1000
                        $0.sequenceNumber = 1
                        $0.revoked = true
                    },
                    .with {
                        $0.index = 2
                        $0.publicKey = publicKeys[2]
                        $0.signAlgo = 3
                        $0.hashAlgo = 3
                        $0.weight = 1
                        $0.revoked = true
                    },
                    .with {
                        $0.index = 3
                        $0.publicKey = publicKeys[3]
                        $0.signAlgo = 3
                        $0.hashAlgo = 3
                        $0.weight = 1000
                    },
                    .with {
                        $0.index = 4
                        $0.publicKey = publicKeys[4]
                        $0.signAlgo = 3
                        $0.hashAlgo = 3
                        $0.weight = 1
                    },
                    .with {
                        $0.index = 5
                        $0.publicKey = publicKeys[5]
                        $0.signAlgo = 3
                        $0.hashAlgo = 3
                        $0.weight = 1
                    },
                    .with {
                        $0.index = 6
                        $0.publicKey = publicKeys[6]
                        $0.signAlgo = 3
                        $0.hashAlgo = 3
                        $0.weight = 1
                    }
                ]
                $0.contracts = contracts
            }
        }
        accessAPIClient.enqueueGetAccountAtLatestBlockResponse(response)

        // Act
        let result = try sut.getAccountAtLatestBlock(
            address: address)
            .wait()

        // Assert
        XCTAssertFalse(accessAPIClient.hasGetAccountAtLatestBlockResponsesRemaining)
        let expected = Account(
            address: address,
            balance: balance,
            code: code,
            keys: [
                .init(
                    index: 0,
                    publicKey: try PublicKey(data: publicKeys[0], signatureAlgorithm: .ecdsaSecp256k1),
                    signatureAlgorithm: .ecdsaSecp256k1,
                    hashAlgorithm: .sha3_256,
                    weight: 999,
                    sequenceNumber: 11),
                .init(
                    index: 1,
                    publicKey: try PublicKey(data: publicKeys[1], signatureAlgorithm: .ecdsaSecp256k1),
                    signatureAlgorithm: .ecdsaSecp256k1,
                    hashAlgorithm: .sha3_256,
                    weight: 1000,
                    sequenceNumber: 1,
                    revoked: true),
                .init(
                    index: 2,
                    publicKey: try PublicKey(data: publicKeys[2], signatureAlgorithm: .ecdsaSecp256k1),
                    signatureAlgorithm: .ecdsaSecp256k1,
                    hashAlgorithm: .sha3_256,
                    weight: 1,
                    sequenceNumber: 0,
                    revoked: true),
                .init(
                    index: 3,
                    publicKey: try PublicKey(data: publicKeys[3], signatureAlgorithm: .ecdsaSecp256k1),
                    signatureAlgorithm: .ecdsaSecp256k1,
                    hashAlgorithm: .sha3_256,
                    weight: 1000,
                    sequenceNumber: 0),
                .init(
                    index: 4,
                    publicKey: try PublicKey(data: publicKeys[4], signatureAlgorithm: .ecdsaSecp256k1),
                    signatureAlgorithm: .ecdsaSecp256k1,
                    hashAlgorithm: .sha3_256,
                    weight: 1,
                    sequenceNumber: 0),
                .init(
                    index: 5,
                    publicKey: try PublicKey(data: publicKeys[5], signatureAlgorithm: .ecdsaSecp256k1),
                    signatureAlgorithm: .ecdsaSecp256k1,
                    hashAlgorithm: .sha3_256,
                    weight: 1,
                    sequenceNumber: 0),
                .init(
                    index: 6,
                    publicKey: try PublicKey(data: publicKeys[6], signatureAlgorithm: .ecdsaSecp256k1),
                    signatureAlgorithm: .ecdsaSecp256k1,
                    hashAlgorithm: .sha3_256,
                    weight: 1,
                    sequenceNumber: 0)
            ],
            contracts: contracts)
        XCTAssertEqual(result, expected)
    }

    func testGetAccountAtBlockHeight() throws {
        // Arrange
        let address = Address(hexString: "0x8f06737debc97668")
        let blockHeight: UInt64 = 69788156
        let balance: UInt64 = 20000098260
        let publicKey: Data = Data(hex: "2b0bf247520770a4bad19e07f6d6b1e8f0542da564154087e2681b175b4432ec2c7b09a52d34dabe0a887ea0f96b067e52c6a0792dcff730fe78a6c5fbbf0a9c")
        let response = try Flow_Access_AccountResponse.with {
            $0.account = try .with {
                $0.address = address.data
                $0.balance = balance
                $0.keys = [
                    .with {
                        $0.publicKey = publicKey
                        $0.signAlgo = 2
                        $0.hashAlgo = 3
                        $0.weight = 1000
                    }
                ]
                $0.contracts = ["FlowToken": try Utils.getTestData(name: "FlowToken.cdc")]
            }
        }
        accessAPIClient.enqueueGetAccountAtBlockHeightResponse(response)

        // Act
        let result = try sut.getAccountAtBlockHeight(
            address: address,
            blockHeight: blockHeight)
            .wait()

        // Assert
        XCTAssertFalse(accessAPIClient.hasGetAccountAtBlockHeightResponsesRemaining)
        let expected = Account(
            address: address,
            balance: balance,
            code: Data(),
            keys: [
                .init(
                    index: 0,
                    publicKey: try PublicKey(data: publicKey, signatureAlgorithm: .ecdsaP256),
                    signatureAlgorithm: .ecdsaP256,
                    hashAlgorithm: .sha3_256,
                    weight: 1000,
                    sequenceNumber: 0)
            ],
            contracts: [
                "FlowToken": try Utils.getTestData(name: "FlowToken.cdc")
            ])
        XCTAssertEqual(result, expected)
    }

    func testExecuteScriptAtLatestBlock() throws {
        // Arrange
        let arguments: [Cadence.Value] = [.address(Address(hexString: "0x76d6c5f3189b2b3e"))]
        let value = "{\"type\":\"UFix64\",\"value\":\"999.71164129\"}\n"
        let response = Flow_Access_ExecuteScriptResponse.with {
            $0.value = value.data(using: .utf8)!
        }
        accessAPIClient.enqueueExecuteScriptAtLatestBlockResponse(response)

        // Act
        let result = try sut.executeScriptAtLatestBlock(
            script: try Utils.getTestData(name: "getFlowBalance.cdc"),
            arguments: arguments)
            .wait()

        // Assert
        XCTAssertFalse(accessAPIClient.hasExecuteScriptAtLatestBlockResponsesRemaining)
        let expected = Cadence.Value.ufix64(Decimal(string: "999.71164129")!)
        XCTAssertEqual(result, expected)
    }

    func testExecuteScriptAtBlockID() throws {
        // Arrange
        let id = Identifier(hexString: "243263c9db22d59b4d1e835e9b38fc8eca89d47cebf1e06c885fab4c28a72f9e")
        let arguments: [Cadence.Value] = [.address(Address(hexString: "0x76d6c5f3189b2b3e"))]
        let value = "{\"type\":\"UFix64\",\"value\":\"999.71164129\"}\n"
        let response = Flow_Access_ExecuteScriptResponse.with {
            $0.value = value.data(using: .utf8)!
        }
        accessAPIClient.enqueueExecuteScriptAtBlockIDResponse(response)

        // Act
        let result = try sut.executeScriptAtBlockID(
            blockId: id,
            script: try Utils.getTestData(name: "getFlowBalance.cdc"),
            arguments: arguments)
            .wait()

        // Assert
        XCTAssertFalse(accessAPIClient.hasExecuteScriptAtBlockIDResponsesRemaining)
        let expected = Cadence.Value.ufix64(Decimal(string: "999.71164129")!)
        XCTAssertEqual(result, expected)
    }

    func testExecuteScriptAtBlockHeight() throws {
        // Arrange
        let height: UInt64 = 5566
        let arguments: [Cadence.Value] = [.address(Address(hexString: "0x76d6c5f3189b2b3e"))]
        let value = "{\"type\":\"UFix64\",\"value\":\"999.71164129\"}\n"
        let response = Flow_Access_ExecuteScriptResponse.with {
            $0.value = value.data(using: .utf8)!
        }
        accessAPIClient.enqueueExecuteScriptAtBlockHeightResponse(response)

        // Act
        let result = try sut.executeScriptAtBlockHeight(
            height: height,
            script: try Utils.getTestData(name: "getFlowBalance.cdc"),
            arguments: arguments)
            .wait()

        // Assert
        XCTAssertFalse(accessAPIClient.hasExecuteScriptAtBlockHeightResponsesRemaining)
        let expected = Cadence.Value.ufix64(Decimal(string: "999.71164129")!)
        XCTAssertEqual(result, expected)
    }

    func testGetEventsForHeightRange() throws {
        // Arrange
        let eventType = "A.7e60df042a9c0868.FlowToken.TokensWithdrawn"
        let startHeight: UInt64 = 69648586
        let endHeight: UInt64 = 69648588
        let result1blockId = Data(hex: "96a62170a3a575a906a0473cd45b2a5d6e6e82c062febef46cd55c3e3b55e331")
        let result1Height: UInt64 = 69648586
        let result1Timestamp: (Int64, Int32) = (1654230794, 533485559)
        let result2blockId = Data(hex: "947eb3aa612e0f7106e864f0cf1f53ac0e99752f74be044372ccfca71ff043c6")
        let result2Height: UInt64 = 69648587
        let result2Timestamp: (Int64, Int32) = (1654230795, 351949584)
        let result2Event1Type = "A.7e60df042a9c0868.FlowToken.TokensWithdrawn"
        let result2Event1TransactionId = Data(hex: "befa32d07edc3b40cec062209944877ee39f48947d4fdfb382a26fe9b98a43fa")
        let result2Event1Payload = "{\"type\":\"Event\",\"value\":{\"id\":\"A.7e60df042a9c0868.FlowToken.TokensWithdrawn\",\"fields\":[{\"name\":\"amount\",\"value\":{\"type\":\"UFix64\",\"value\":\"0.00000169\"}},{\"name\":\"from\",\"value\":{\"type\":\"Optional\",\"value\":{\"type\":\"Address\",\"value\":\"0xebf4ae01d1284af8\"}}}]}}\n".data(using: .utf8)!
        let result3blockId = Data(hex: "c2a78b02deaf78b1cc0a1ce3bb55093cbe0ba75fcc0132585926e5e87e9a9ef5")
        let result3Height: UInt64 = 69648588
        let result3Timestamp: (Int64, Int32) = (1654230799, 265195928)
        let response = Flow_Access_EventsResponse.with {
            $0.results = [
                .with {
                    $0.blockID = result1blockId
                    $0.blockHeight = result1Height
                    $0.blockTimestamp = .with {
                        $0.seconds = result1Timestamp.0
                        $0.nanos = result1Timestamp.1
                    }
                },
                .with {
                    $0.blockID = result2blockId
                    $0.blockHeight = result2Height
                    $0.blockTimestamp = .with {
                        $0.seconds = result2Timestamp.0
                        $0.nanos = result2Timestamp.1
                    }
                    $0.events = [
                        .with {
                            $0.type = result2Event1Type
                            $0.transactionID = result2Event1TransactionId
                            $0.payload = result2Event1Payload
                        }
                    ]
                },
                .with {
                    $0.blockID = result3blockId
                    $0.blockHeight = result3Height
                    $0.blockTimestamp = .with {
                        $0.seconds = result3Timestamp.0
                        $0.nanos = result3Timestamp.1
                    }
                }
            ]
        }
        accessAPIClient.enqueueGetEventsForHeightRangeResponse(response)

        // Act
        let result = try sut.getEventsForHeightRange(
            eventType: eventType,
            startHeight: startHeight,
            endHeight: endHeight)
            .wait()

        // Assert
        XCTAssertFalse(accessAPIClient.hasGetEventsForHeightRangeResponsesRemaining)
        let expected: [BlockEvents] = [
            .init(
                blockId: Identifier(data: result1blockId),
                height: result1Height,
                blockDate: Google_Protobuf_Timestamp(seconds: result1Timestamp.0, nanos: result1Timestamp.1).date,
                events: []),
            .init(
                blockId: Identifier(data: result2blockId),
                height: result2Height,
                blockDate: Google_Protobuf_Timestamp(seconds: result2Timestamp.0, nanos: result2Timestamp.1).date,
                events: [
                    Event(
                        type: result2Event1Type,
                        transactionId: Identifier(data: result2Event1TransactionId),
                        transactionIndex: 0,
                        eventIndex: 0,
                        value: .init(
                            id: result2Event1Type,
                            fields: [
                                .init(name: "amount", value: .ufix64(Decimal(string: "0.00000169")!)),
                                .init(name: "from", value: .optional(.address(Address(hexString: "0xebf4ae01d1284af8"))))
                            ]),
                        payload: result2Event1Payload)
                ]),
            .init(
                blockId: Identifier(data: result3blockId),
                height: result3Height,
                blockDate: Google_Protobuf_Timestamp(seconds: result3Timestamp.0, nanos: result3Timestamp.1).date,
                events: [])
        ]
        XCTAssertEqual(result, expected)
    }

    func testGetEventsForBlockIDs() throws {
        // Arrange
        let eventType = "A.7e60df042a9c0868.FlowToken.TokensWithdrawn"
        let id = Data(hex: "e06759c55e126e5c96ca5427d37fca397311b09bb16fe89ccfe288f950ed2831")
        let id2 = Data(hex: "e03b3346831698b2a578a4ace9469ed488e89e8716c9c6b40f89e9d666f21f3c")
        let result1Height: UInt64 = 68571606
        let result1Timestamp: (Int64, Int32) = (1652833484, 101795094)
        let result1Event1TransactionId = Data(hex: "7ea1f65d4972b701e2c83eb74d6d4884f8b87ae32bf84c9f1cb6bc8237887d92")
        let result1Event1Payload = "{\"type\":\"Event\",\"value\":{\"id\":\"A.7e60df042a9c0868.FlowToken.TokensWithdrawn\",\"fields\":[{\"name\":\"amount\",\"value\":{\"type\":\"UFix64\",\"value\":\"0.00001552\"}},{\"name\":\"from\",\"value\":{\"type\":\"Optional\",\"value\":{\"type\":\"Address\",\"value\":\"0xcb2d04fc89307107\"}}}]}}\n".data(using: .utf8)!
        let result1Event1Index: UInt32 = 2
        let result2Height: UInt64 = 69661888
        let result2Timestamp: (Int64, Int32) = (1654248615, 777493619)
        let response = Flow_Access_EventsResponse.with {
            $0.results = [
                .with {
                    $0.blockID = id
                    $0.blockHeight = result1Height
                    $0.blockTimestamp = .with {
                        $0.seconds = result1Timestamp.0
                        $0.nanos = result1Timestamp.1
                    }
                    $0.events = [
                        .with {
                            $0.type = eventType
                            $0.transactionID = result1Event1TransactionId
                            $0.payload = result1Event1Payload
                            $0.eventIndex = result1Event1Index
                        }
                    ]
                },
                .with {
                    $0.blockID = id2
                    $0.blockHeight = result2Height
                    $0.blockTimestamp = .with {
                        $0.seconds = result2Timestamp.0
                        $0.nanos = result2Timestamp.1
                    }
                }
            ]
        }
        accessAPIClient.enqueueGetEventsForBlockIDsResponse(response)

        // Act
        let result = try sut.getEventsForBlockIDs(
            eventType: eventType,
            blockIds: [Identifier(data: id), Identifier(data: id2)])
            .wait()

        // Assert
        XCTAssertFalse(accessAPIClient.hasGetEventsForBlockIDsResponsesRemaining)
        let expected: [BlockEvents] = [
            .init(
                blockId: Identifier(data: id),
                height: result1Height,
                blockDate: Google_Protobuf_Timestamp(seconds: result1Timestamp.0, nanos: result1Timestamp.1).date,
                events: [
                    .init(
                        type: eventType,
                        transactionId: Identifier(data: result1Event1TransactionId),
                        transactionIndex: 0,
                        eventIndex: Int(result1Event1Index),
                        value: .init(
                            id: eventType,
                            fields: [
                                .init(name: "amount", value: .ufix64(Decimal(string: "0.00001552")!)),
                                .init(name: "from", value:.optional(.address(Address(hexString: "0xcb2d04fc89307107"))) )
                            ]),
                        payload: result1Event1Payload)
                ]),
            .init(
                blockId: Identifier(data: id2),
                height: result2Height,
                blockDate: Google_Protobuf_Timestamp(seconds: result2Timestamp.0, nanos: result2Timestamp.1).date,
                events: [])
        ]
        XCTAssertEqual(result, expected)
    }

    func testGetLatestProtocolStateSnapshot() throws {
        // Arrange
        let protocolState = try Utils.getHexData(name: "protocolState.hex")
        let response = Flow_Access_ProtocolStateSnapshotResponse.with {
            $0.serializedSnapshot = protocolState
        }
        accessAPIClient.enqueueGetLatestProtocolStateSnapshotResponse(response)

        // Act
        let result = try sut.getLatestProtocolStateSnapshot().wait()

        // Assert
        XCTAssertFalse(accessAPIClient.hasGetLatestProtocolStateSnapshotResponsesRemaining)
        XCTAssertEqual(result, protocolState)
    }

    func testGetExecutionResultForBlockID() throws {
        // Arrange
        let id = Data(hex: "f02f42084d41186c3de1f0badbfbde602ee91f0f1c4224250d58de32cd561fb8")
        let previousResultId = Data(hex: "e8426df245554bcfe890176531406786739e414abcd2ebc926900743997f1e77")
        let startState = Data(hex: "daf71cbc8e0bc7772d5dfc5752d67a6ac3d9759bb64cf18ca351b421e15c38c6")
        let eventCollection = Data(hex: "0e5751c026e543b2e8ab2eb06099daa1d1e5df47778f7787faab45cdf12fe3a8")
        let numberOfTransactions: UInt32 = 1
        let endState = Data(hex: "daf71cbc8e0bc7772d5dfc5752d67a6ac3d9759bb64cf18ca351b421e15c38c6")
        let response = Flow_Access_ExecutionResultForBlockIDResponse.with {
            $0.executionResult = .with {
                $0.blockID = id
                $0.previousResultID = previousResultId
                $0.chunks = [
                    .with {
                        $0.startState = startState
                        $0.eventCollection = eventCollection
                        $0.blockID = id
                        $0.numberOfTransactions = numberOfTransactions
                        $0.endState = endState
                    }
                ]
            }
        }
        accessAPIClient.enqueueGetExecutionResultForBlockIDResponse(response)

        // Act
        let result = try sut.getExecutionResultForBlockID(blockId: Identifier(data: id)).wait()

        // Assert
        XCTAssertFalse(accessAPIClient.hasGetExecutionResultForBlockIDResponsesRemaining)
        let expected = ExecutionResult(
            previousResultId: Identifier(data: previousResultId),
            blockId: Identifier(data: id),
            chunks: [
                Chunk(
                    collectionIndex: 0,
                    startState: StateCommitment(data: startState),
                    eventCollection: eventCollection,
                    blockId: Identifier(data: id),
                    totalComputationUsed: 0,
                    numberOfTransactions: numberOfTransactions,
                    index: 0,
                    endState: StateCommitment(data: endState))
            ],
            serviceEvents: [])
        XCTAssertEqual(result, expected)
    }

}
