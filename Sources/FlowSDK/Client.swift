//
//  Client.swift
//
//  Created by Scott on 2022/5/18.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation
import Cadence
import NIO
import GRPC

/// A gRPC Client for the Flow Access API.
final public class Client {

    private let eventLoopGroup: EventLoopGroup
    private let accessAPIClient: Flow_Access_AccessAPIAsyncClientProtocol

    public convenience init(host: String, port: Int) {
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        let channel = ClientConnection(
            configuration: .default(
                target: .host(host, port: port),
                eventLoopGroup: eventLoopGroup))
        self.init(
            eventLoopGroup: eventLoopGroup,
            accessAPIClient: Flow_Access_AccessAPIAsyncClient(channel: channel))
    }

    public convenience init(network: Network) {
        let endpoint = network.endpoint
        self.init(host: endpoint.host, port: endpoint.port)
    }

    init(eventLoopGroup: EventLoopGroup,
         accessAPIClient: Flow_Access_AccessAPIAsyncClientProtocol) {
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
    public func ping(options: CallOptions? = nil) async throws {
        let request = Flow_Access_PingRequest()
        _ = try await accessAPIClient.ping(request, callOptions: options)
    }

    /// Gets a block header by ID.
    public func getLatestBlockHeader(
        isSealed: Bool,
        options: CallOptions? = nil
    ) async throws -> BlockHeader? {
        let request = Flow_Access_GetLatestBlockHeaderRequest.with {
            $0.isSealed = false
        }
        let response = try await accessAPIClient.getLatestBlockHeader(request, callOptions: options)
        return response.hasBlock ? BlockHeader(response.block) : nil
    }

    /// Gets a block header by ID.
    public func getBlockHeaderById(
        blockId: Identifier,
        options: CallOptions? = nil
    ) async throws -> BlockHeader? {
        let request = Flow_Access_GetBlockHeaderByIDRequest.with {
            $0.id = blockId.data
        }
        let response = try await accessAPIClient.getBlockHeaderByID(request, callOptions: options)
        return response.hasBlock ? BlockHeader(response.block) : nil
    }

    /// Gets a block header by height.
    public func getBlockHeaderByHeight(
        height: UInt64,
        options: CallOptions? = nil
    ) async throws -> BlockHeader? {
        let request = Flow_Access_GetBlockHeaderByHeightRequest.with {
            $0.height = height
        }
        let response = try await accessAPIClient.getBlockHeaderByHeight(request, callOptions: options)
        return response.hasBlock ? BlockHeader(response.block) : nil
    }

    /// Gets the full payload of the latest sealed or unsealed block.
    public func getLatestBlock(
        isSealed: Bool,
        options: CallOptions? = nil
    ) async throws -> Block? {
        let request = Flow_Access_GetLatestBlockRequest.with {
            $0.isSealed = isSealed
        }
        let response = try await accessAPIClient.getLatestBlock(request, callOptions: options)
        return response.hasBlock ? Block(response.block) : nil
    }

    /// Gets a full block by ID.
    public func getBlockByID(
        blockId: Identifier,
        options: CallOptions? = nil
    ) async throws -> Block? {
        let request = Flow_Access_GetBlockByIDRequest.with {
            $0.id = blockId.data
        }
        let response = try await accessAPIClient.getBlockByID(request, callOptions: options)
        return response.hasBlock ? Block(response.block) : nil
    }

    /// Gets a full block by height.
    public func getBlockByHeight(
        height: UInt64,
        options: CallOptions? = nil
    ) async throws -> Block? {
        let request = Flow_Access_GetBlockByHeightRequest.with {
            $0.height = height
        }
        let response = try await accessAPIClient.getBlockByHeight(request, callOptions: options)
        return response.hasBlock ? Block(response.block) : nil
    }

    /// Gets a collection by ID.
    public func getCollection(
        collectionId: Identifier,
        options: CallOptions? = nil
    ) async throws -> Collection? {
        let request = Flow_Access_GetCollectionByIDRequest.with {
            $0.id = collectionId.data
        }
        let response = try await accessAPIClient.getCollectionByID(request, callOptions: options)
        return response.hasCollection ? Collection(response.collection) : nil
    }

    /// Submits a transaction to the network.
    public func sendTransaction(
        transaction: Transaction,
        options: CallOptions? = nil
    ) async throws -> Identifier {
        let request = Flow_Access_SendTransactionRequest.with {
            $0.transaction = convertTransaction(transaction)
        }
        let response = try await accessAPIClient.sendTransaction(request, callOptions: options)
        return Identifier(data: response.id)
    }

    /// Gets a transaction by ID.
    public func getTransaction(
        id: Identifier,
        options: CallOptions? = nil
    ) async throws -> Transaction? {
        let request = Flow_Access_GetTransactionRequest.with {
            $0.id = id.data
        }
        let response = try await accessAPIClient.getTransaction(request, callOptions: options)
        return response.hasTransaction ? Transaction(response.transaction) : nil
    }

    /// Gets the result of a transaction.
    public func getTransactionResult(
        id: Identifier,
        options: CallOptions? = nil
    ) async throws -> TransactionResult {
        let request = Flow_Access_GetTransactionRequest.with {
            $0.id = id.data
        }
        let response = try await accessAPIClient.getTransactionResult(request, callOptions: options)
        return try TransactionResult(response)
    }

    /// Gets an account by address at the latest sealed block.
    public func getAccountAtLatestBlock(
        address: Address,
        options: CallOptions? = nil
    ) async throws -> Account? {
        let request = Flow_Access_GetAccountAtLatestBlockRequest.with {
            $0.address = address.data
        }
        let response = try await accessAPIClient.getAccountAtLatestBlock(request, callOptions: options)
        return response.hasAccount ? try Account(response.account) : nil
    }

    /// Gets an account by address at the given block height
    public func getAccountAtBlockHeight(
        address: Address,
        blockHeight: UInt64,
        options: CallOptions? = nil
    ) async throws -> Account? {
        let request = Flow_Access_GetAccountAtBlockHeightRequest.with {
            $0.address = address.data
            $0.blockHeight = blockHeight
        }
        let response = try await accessAPIClient.getAccountAtBlockHeight(request, callOptions: options)
        return response.hasAccount ? try Account(response.account) : nil
    }

    /// Executes a read-only Cadence script against the latest sealed execution state.
    public func executeScriptAtLatestBlock(
        script: Data,
        arguments: [Cadence.Value] = [],
        options: CallOptions? = nil
    ) async throws -> Cadence.Value {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .withoutEscapingSlashes
        let request = try Flow_Access_ExecuteScriptAtLatestBlockRequest.with {
            $0.script = script
            $0.arguments = try arguments.map { try encoder.encode($0) }
        }
        let response = try await accessAPIClient.executeScriptAtLatestBlock(request, callOptions: options)
        return try Cadence.Value.decode(data: response.value)
    }

    /// Executes a ready-only Cadence script against the execution state at the block with the given ID.
    public func executeScriptAtBlockID(
        blockId: Identifier,
        script: Data,
        arguments: [Cadence.Value],
        options: CallOptions? = nil
    ) async throws -> Cadence.Value {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .withoutEscapingSlashes
        let request = try Flow_Access_ExecuteScriptAtBlockIDRequest.with {
            $0.blockID = blockId.data
            $0.script = script
            $0.arguments = try arguments.map { try encoder.encode($0) }
        }
        let response = try await accessAPIClient.executeScriptAtBlockID(request, callOptions: options)
        return try Cadence.Value.decode(data: response.value)
    }

    /// Executes a ready-only Cadence script against the execution state at the given block height.
    public func executeScriptAtBlockHeight(
        height: UInt64,
        script: Data,
        arguments: [Cadence.Value],
        options: CallOptions? = nil
    ) async throws -> Cadence.Value {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .withoutEscapingSlashes
        let request = try Flow_Access_ExecuteScriptAtBlockHeightRequest.with {
            $0.blockHeight = height
            $0.script = script
            $0.arguments = try arguments.map { try encoder.encode($0) }
        }
        let response = try await accessAPIClient.executeScriptAtBlockHeight(request, callOptions: options)
        return try Cadence.Value.decode(data: response.value)
    }

    /// Retrieves events for all sealed blocks between the start and end block heights (inclusive) with the given type.
    public func getEventsForHeightRange(
        eventType: String,
        startHeight: UInt64,
        endHeight: UInt64,
        options: CallOptions? = nil
    ) async throws -> [BlockEvents] {
        let request = Flow_Access_GetEventsForHeightRangeRequest.with {
            $0.type = eventType
            $0.startHeight = startHeight
            $0.endHeight = endHeight
        }
        let response = try await accessAPIClient.getEventsForHeightRange(request, callOptions: options)
        return try response.results.map { try BlockEvents($0) }
    }

    /// Retrieves events with the given type from the specified block IDs.
    public func getEventsForBlockIDs(
        eventType: String,
        blockIds: [Identifier],
        options: CallOptions? = nil
    ) async throws -> [BlockEvents] {
        let request = Flow_Access_GetEventsForBlockIDsRequest.with {
            $0.type = eventType
            $0.blockIds = blockIds.map { $0.data }
        }
        let response = try await accessAPIClient.getEventsForBlockIDs(request, callOptions: options)
        return try response.results.map { try BlockEvents($0) }
    }

    /// Retrieves the Flow network details
    public func getNetworkParameters(
        options: CallOptions? = nil
    ) async throws -> String {
        let request = Flow_Access_GetNetworkParametersRequest()

        let response = try await accessAPIClient.getNetworkParameters(request, callOptions: options)
        return response.chainID
    }

    /// Retrieves the latest snapshot of the protocol state in serialized form. This is used to generate a root snapshot file
    /// used by Flow nodes to bootstrap their local protocol state database.
    public func getLatestProtocolStateSnapshot(
        options: CallOptions? = nil
    ) async throws -> Data {
        let request = Flow_Access_GetLatestProtocolStateSnapshotRequest()
        let response = try await accessAPIClient.getLatestProtocolStateSnapshot(request, callOptions: options)
        return response.serializedSnapshot
    }

    /// Gets the execution results at the block ID.
    public func getExecutionResultForBlockID(
        blockId: Identifier,
        options: CallOptions? = nil
    ) async throws -> ExecutionResult? {
        let request = Flow_Access_GetExecutionResultForBlockIDRequest.with {
            $0.blockID = blockId.data
        }
        let response = try await accessAPIClient.getExecutionResultForBlockID(request, callOptions: options)
        return response.hasExecutionResult ? ExecutionResult(response.executionResult) : nil
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
