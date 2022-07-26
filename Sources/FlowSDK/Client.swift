//
//  Client.swift
//
//  Created by Scott on 2022/5/18.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation
import Cadence
#if !COCOAPODS
import Protobuf
#endif
import NIO
import GRPC

/// A gRPC Client for the Flow Access API.
final public class Client {

    private let eventLoopGroup: EventLoopGroup
    private let accessAPIClient: Flow_Access_AccessAPIClientProtocol

    public convenience init(host: String, port: Int) {
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        let channel = ClientConnection(
            configuration: .default(
                target: .host(host, port: port),
                eventLoopGroup: eventLoopGroup))
        self.init(
            eventLoopGroup: eventLoopGroup,
            accessAPIClient: Flow_Access_AccessAPIClient(channel: channel))
    }

    public convenience init(network: Network) {
        let endpoint = network.endpoint
        self.init(host: endpoint.host, port: endpoint.port)
    }

    init(eventLoopGroup: EventLoopGroup,
         accessAPIClient: Flow_Access_AccessAPIClientProtocol) {
        self.eventLoopGroup = eventLoopGroup
        self.accessAPIClient = accessAPIClient
    }

    /// Close stops the client connection to the access node.
    public func close(_ callback: ((Error?) -> Void)? = nil) {
        eventLoopGroup.shutdownGracefully { [weak self] error in
            if let error = error {
                callback?(error)
            }
            self?.accessAPIClient.channel.close()
                .whenComplete{ result in
                    switch result {
                    case .success:
                        break
                    case let .failure(error):
                        callback?(error)
                    }
                }
        }
    }

    /// Check if the access node is alive and healthy.
    public func ping(options: CallOptions? = nil) -> EventLoopFuture<Void> {
        let request = Flow_Access_PingRequest()
        return accessAPIClient.ping(request, callOptions: options)
            .response
            .map { _ in () }
    }

    /// Gets a block header by ID.
    public func getLatestBlockHeader(
        isSealed: Bool,
        options: CallOptions? = nil
    ) -> EventLoopFuture<BlockHeader?> {
        let request = Flow_Access_GetLatestBlockHeaderRequest.with {
            $0.isSealed = false
        }
        return accessAPIClient.getLatestBlockHeader(request, callOptions: options)
            .response
            .map { $0.hasBlock ? BlockHeader($0.block) : nil }
    }

    /// Gets a block header by ID.
    public func getBlockHeaderById(
        blockId: Identifier,
        options: CallOptions? = nil
    ) -> EventLoopFuture<BlockHeader?> {
        let request = Flow_Access_GetBlockHeaderByIDRequest.with {
            $0.id = blockId.data
        }
        return accessAPIClient.getBlockHeaderByID(request, callOptions: options)
            .response
            .map { $0.hasBlock ? BlockHeader($0.block) : nil }
    }

    /// Gets a block header by height.
    public func getBlockHeaderByHeight(
        height: UInt64,
        options: CallOptions? = nil
    ) -> EventLoopFuture<BlockHeader?> {
        let request = Flow_Access_GetBlockHeaderByHeightRequest.with {
            $0.height = height
        }
        return accessAPIClient.getBlockHeaderByHeight(request, callOptions: options)
            .response
            .map { $0.hasBlock ? BlockHeader($0.block) : nil }
    }

    /// Gets the full payload of the latest sealed or unsealed block.
    public func getLatestBlock(
        isSealed: Bool,
        options: CallOptions? = nil
    ) -> EventLoopFuture<Block?> {
        let request = Flow_Access_GetLatestBlockRequest.with {
            $0.isSealed = isSealed
        }
        return accessAPIClient.getLatestBlock(request, callOptions: options)
            .response
            .map { $0.hasBlock ? Block($0.block) : nil }
    }

    /// Gets a full block by ID.
    public func getBlockByID(
        blockId: Identifier,
        options: CallOptions? = nil
    ) -> EventLoopFuture<Block?> {
        let request = Flow_Access_GetBlockByIDRequest.with {
            $0.id = blockId.data
        }
        return accessAPIClient.getBlockByID(request, callOptions: options)
            .response
            .map { $0.hasBlock ? Block($0.block) : nil }
    }

    /// Gets a full block by height.
    public func getBlockByHeight(
        height: UInt64,
        options: CallOptions? = nil
    ) -> EventLoopFuture<Block?> {
        let request = Flow_Access_GetBlockByHeightRequest.with {
            $0.height = height
        }
        return accessAPIClient.getBlockByHeight(request, callOptions: options)
            .response
            .map { $0.hasBlock ? Block($0.block) : nil }
    }

    /// Gets a collection by ID.
    public func getCollection(
        collectionId: Identifier,
        options: CallOptions? = nil
    ) -> EventLoopFuture<Collection?> {
        let request = Flow_Access_GetCollectionByIDRequest.with {
            $0.id = collectionId.data
        }
        return accessAPIClient.getCollectionByID(request, callOptions: options)
            .response
            .map { $0.hasCollection ? Collection($0.collection) : nil }
    }

    /// Submits a transaction to the network.
    public func sendTransaction(
        transaction: Transaction,
        options: CallOptions? = nil
    ) -> EventLoopFuture<Identifier> {
        let request = Flow_Access_SendTransactionRequest.with {
            $0.transaction = convertTransaction(transaction)
        }
        return accessAPIClient.sendTransaction(request, callOptions: options)
            .response
            .map { Identifier(data: $0.id) }
    }

    /// Gets a transaction by ID.
    public func getTransaction(
        id: Identifier,
        options: CallOptions? = nil
    ) -> EventLoopFuture<Transaction?> {
        let request = Flow_Access_GetTransactionRequest.with {
            $0.id = id.data
        }
        return accessAPIClient.getTransaction(request, callOptions: options)
            .response
            .map { $0.hasTransaction ? Transaction($0.transaction) : nil }
    }

    /// Gets the result of a transaction.
    public func getTransactionResult(
        id: Identifier,
        options: CallOptions? = nil
    ) -> EventLoopFuture<TransactionResult> {
        let request = Flow_Access_GetTransactionRequest.with {
            $0.id = id.data
        }
        return accessAPIClient.getTransactionResult(request, callOptions: options)
            .response
            .flatMapThrowing{ try TransactionResult($0) }
    }

    /// Gets an account by address at the latest sealed block.
    public func getAccountAtLatestBlock(
        address: Address,
        options: CallOptions? = nil
    ) -> EventLoopFuture<Account?> {
        let request = Flow_Access_GetAccountAtLatestBlockRequest.with {
            $0.address = address.data
        }
        return accessAPIClient.getAccountAtLatestBlock(request, callOptions: options)
            .response
            .flatMapThrowing { $0.hasAccount ? try Account($0.account) : nil }
    }

    /// Gets an account by address at the given block height
    public func getAccountAtBlockHeight(
        address: Address,
        blockHeight: UInt64,
        options: CallOptions? = nil
    ) -> EventLoopFuture<Account?> {
        let request = Flow_Access_GetAccountAtBlockHeightRequest.with {
            $0.address = address.data
            $0.blockHeight = blockHeight
        }
        return accessAPIClient.getAccountAtBlockHeight(request, callOptions: options)
            .response
            .flatMapThrowing { $0.hasAccount ? try Account($0.account) : nil }
    }

    /// Executes a read-only Cadence script against the latest sealed execution state.
    public func executeScriptAtLatestBlock(
        script: Data,
        arguments: [Cadence.Value] = [],
        options: CallOptions? = nil
    ) -> EventLoopFuture<Cadence.Value> {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .withoutEscapingSlashes
        let request: Flow_Access_ExecuteScriptAtLatestBlockRequest
        do {
            request = try Flow_Access_ExecuteScriptAtLatestBlockRequest.with {
                $0.script = script
                $0.arguments = try arguments.map { try encoder.encode($0) }
            }
        } catch {
            let eventLoop = eventLoopGroup.next()
            let promise = eventLoop.makePromise(of: Cadence.Value.self)
            promise.fail(error)
            return promise.futureResult
        }
        return accessAPIClient.executeScriptAtLatestBlock(request, callOptions: options)
            .response
            .flatMapThrowing{ try Cadence.Value.decode(data: $0.value) }
    }

    /// Executes a ready-only Cadence script against the execution state at the block with the given ID.
    public func executeScriptAtBlockID(
        blockId: Identifier,
        script: Data,
        arguments: [Cadence.Value],
        options: CallOptions? = nil
    ) -> EventLoopFuture<Cadence.Value> {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .withoutEscapingSlashes
        let request: Flow_Access_ExecuteScriptAtBlockIDRequest
        do {
            request = try Flow_Access_ExecuteScriptAtBlockIDRequest.with {
                $0.blockID = blockId.data
                $0.script = script
                $0.arguments = try arguments.map { try encoder.encode($0) }
            }
        } catch {
            let eventLoop = eventLoopGroup.next()
            let promise = eventLoop.makePromise(of: Cadence.Value.self)
            promise.fail(error)
            return promise.futureResult
        }
        return accessAPIClient.executeScriptAtBlockID(request, callOptions: options)
            .response
            .flatMapThrowing{ try Cadence.Value.decode(data: $0.value) }
    }

    /// Executes a ready-only Cadence script against the execution state at the given block height.
    public func executeScriptAtBlockHeight(
        height: UInt64,
        script: Data,
        arguments: [Cadence.Value],
        options: CallOptions? = nil
    ) -> EventLoopFuture<Cadence.Value> {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .withoutEscapingSlashes
        let request: Flow_Access_ExecuteScriptAtBlockHeightRequest
        do {
            request = try Flow_Access_ExecuteScriptAtBlockHeightRequest.with {
                $0.blockHeight = height
                $0.script = script
                $0.arguments = try arguments.map { try encoder.encode($0) }
            }
        } catch {
            let eventLoop = eventLoopGroup.next()
            let promise = eventLoop.makePromise(of: Cadence.Value.self)
            promise.fail(error)
            return promise.futureResult
        }
        return accessAPIClient.executeScriptAtBlockHeight(request, callOptions: options)
            .response
            .flatMapThrowing{ try Cadence.Value.decode(data: $0.value) }
    }

    /// Retrieves events for all sealed blocks between the start and end block heights (inclusive) with the given type.
    public func getEventsForHeightRange(
        eventType: String,
        startHeight: UInt64,
        endHeight: UInt64,
        options: CallOptions? = nil
    ) -> EventLoopFuture<[BlockEvents]> {
        let request = Flow_Access_GetEventsForHeightRangeRequest.with {
            $0.type = eventType
            $0.startHeight = startHeight
            $0.endHeight = endHeight
        }
        return accessAPIClient.getEventsForHeightRange(request, callOptions: options)
            .response
            .flatMapThrowing { try $0.results.map { try BlockEvents($0) } }
    }

    /// Retrieves events with the given type from the specified block IDs.
    public func getEventsForBlockIDs(
        eventType: String,
        blockIds: [Identifier],
        options: CallOptions? = nil
    ) -> EventLoopFuture<[BlockEvents]> {
        let request = Flow_Access_GetEventsForBlockIDsRequest.with {
            $0.type = eventType
            $0.blockIds = blockIds.map { $0.data }
        }
        return accessAPIClient.getEventsForBlockIDs(request, callOptions: options)
            .response
            .flatMapThrowing { try $0.results.map { try BlockEvents($0) } }
    }

    /// Retrieves the Flow network details
    public func getNetworkParameters(
        options: CallOptions? = nil
    ) -> EventLoopFuture<String> {
        let request = Flow_Access_GetNetworkParametersRequest()

        return accessAPIClient.getNetworkParameters(request, callOptions: options)
            .response
            .map { $0.chainID }
    }

    /// Retrieves the latest snapshot of the protocol state in serialized form. This is used to generate a root snapshot file
    /// used by Flow nodes to bootstrap their local protocol state database.
    public func getLatestProtocolStateSnapshot(
        options: CallOptions? = nil
    ) -> EventLoopFuture<Data> {
        let request = Flow_Access_GetLatestProtocolStateSnapshotRequest()
        return accessAPIClient.getLatestProtocolStateSnapshot(request, callOptions: options)
            .response
            .map { $0.serializedSnapshot }
    }

    /// Gets the execution results at the block ID.
    public func getExecutionResultForBlockID(
        blockId: Identifier,
        options: CallOptions? = nil
    ) -> EventLoopFuture<ExecutionResult?> {
        let request = Flow_Access_GetExecutionResultForBlockIDRequest.with {
            $0.blockID = blockId.data
        }
        return accessAPIClient.getExecutionResultForBlockID(request, callOptions: options)
            .response
            .map { $0.hasExecutionResult ? ExecutionResult($0.executionResult) : nil }
    }

}

extension Client {

    private func convertTransaction(_ transaction: Transaction) -> Flow_Entities_Transaction {
        Flow_Entities_Transaction.with {
            $0.script = transaction.script
            $0.arguments = transaction.arguments
            $0.referenceBlockID = transaction.referenceBlockId.data
            $0.gasLimit = transaction.gasLimit
            $0.proposalKey = .with {
                $0.address = transaction.proposalKey.address.data
                $0.keyID = UInt32(transaction.proposalKey.keyIndex)
                $0.sequenceNumber = transaction.proposalKey.sequenceNumber
            }
            $0.payer = transaction.payer.data
            $0.authorizers = transaction.authorizers.map { $0.data }
            $0.payloadSignatures = transaction.payloadSignatures.map { payloadSignature in
                .with {
                    $0.address = payloadSignature.address.data
                    $0.keyID = UInt32(payloadSignature.keyIndex)
                    $0.signature = payloadSignature.signature
                }
            }
            $0.envelopeSignatures = transaction.envelopeSignatures.map { envelopeSignature in
                .with {
                    $0.address = envelopeSignature.address.data
                    $0.keyID = UInt32(envelopeSignature.keyIndex)
                    $0.signature = envelopeSignature.signature
                }
            }
        }
    }

}
