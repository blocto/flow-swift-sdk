//
//  FlowAccessAPIProvider.swift
//
//  Created by Scott on 2022/7/27.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation
import NIO
import GRPC
import SwiftProtobuf
import FlowSDK

final class FlowAccessAPIProvider: Flow_Access_AccessAPIAsyncProvider {

    private var pingResponses = [Flow_Access_PingResponse]()
    var hasPingResponsesRemaining: Bool { !pingResponses.isEmpty }
    func enqueuePingResponse(_ response: Flow_Access_PingResponse) {
        pingResponses.append(response)
    }
    func ping(request: Flow_Access_PingRequest, context: GRPCAsyncServerCallContext) async throws -> Flow_Access_PingResponse {
        pingResponses.removeFirst()
    }

    private var getLatestBlockHeaderResponses = [Flow_Access_BlockHeaderResponse]()
    var hasGetLatestBlockHeaderResponsesRemaining: Bool { !getLatestBlockHeaderResponses.isEmpty }
    func enqueueGetLatestBlockHeaderResponse(_ response: Flow_Access_BlockHeaderResponse) {
        getLatestBlockHeaderResponses.append(response)
    }
    func getLatestBlockHeader(request: Flow_Access_GetLatestBlockHeaderRequest, context: GRPCAsyncServerCallContext) async throws -> Flow_Access_BlockHeaderResponse {
        getLatestBlockHeaderResponses.removeFirst()
    }

    private var getBlockHeaderByIDResponses = [Flow_Access_BlockHeaderResponse]()
    var hasGetBlockHeaderByIDResponsesRemaining: Bool { !getBlockHeaderByIDResponses.isEmpty }
    func enqueueGetBlockHeaderByIDResponse(_ response: Flow_Access_BlockHeaderResponse) {
        getBlockHeaderByIDResponses.append(response)
    }
    func getBlockHeaderByID(request: Flow_Access_GetBlockHeaderByIDRequest, context: GRPCAsyncServerCallContext) async throws -> Flow_Access_BlockHeaderResponse {
        getBlockHeaderByIDResponses.removeFirst()
    }

    private var getBlockHeaderByHeightResponses = [Flow_Access_BlockHeaderResponse]()
    var hasGetBlockHeaderByHeightResponsesRemaining: Bool { !getBlockHeaderByHeightResponses.isEmpty }
    func enqueueGetBlockHeaderByHeightResponse(_ response: Flow_Access_BlockHeaderResponse) {
        getBlockHeaderByHeightResponses.append(response)
    }
    func getBlockHeaderByHeight(request: Flow_Access_GetBlockHeaderByHeightRequest, context: GRPCAsyncServerCallContext) async throws -> Flow_Access_BlockHeaderResponse {
        getBlockHeaderByHeightResponses.removeFirst()
    }

    private var getLatestBlockResponses = [Flow_Access_BlockResponse]()
    var hasGetLatestBlockResponsesRemaining: Bool { !getLatestBlockResponses.isEmpty }
    func enqueueGetLatestBlockResponse(_ response: Flow_Access_BlockResponse) {
        getLatestBlockResponses.append(response)
    }
    func getLatestBlock(request: Flow_Access_GetLatestBlockRequest, context: GRPCAsyncServerCallContext) async throws -> Flow_Access_BlockResponse {
        getLatestBlockResponses.removeFirst()
    }

    private var getBlockByIDResponses = [Flow_Access_BlockResponse]()
    var hasGetBlockByIDResponsesRemaining: Bool { !getBlockByIDResponses.isEmpty }
    func enqueueGetBlockByIDResponse(_ response: Flow_Access_BlockResponse) {
        getBlockByIDResponses.append(response)
    }
    func getBlockByID(request: Flow_Access_GetBlockByIDRequest, context: GRPCAsyncServerCallContext) async throws -> Flow_Access_BlockResponse {
        getBlockByIDResponses.removeFirst()
    }

    private var getBlockByHeightResponses = [Flow_Access_BlockResponse]()
    var hasGetBlockByHeightResponsesRemaining: Bool { !getBlockByHeightResponses.isEmpty }
    func enqueueGetBlockByHeightResponse(_ response: Flow_Access_BlockResponse) {
        getBlockByHeightResponses.append(response)
    }
    func getBlockByHeight(request: Flow_Access_GetBlockByHeightRequest, context: GRPCAsyncServerCallContext) async throws -> Flow_Access_BlockResponse {
        getBlockByHeightResponses.removeFirst()
    }

    private var getCollectionByIDResponses = [Flow_Access_CollectionResponse]()
    var hasGetCollectionByIDResponsesRemaining: Bool { !getCollectionByIDResponses.isEmpty }
    func enqueueGetCollectionByIDResponse(_ response: Flow_Access_CollectionResponse) {
        getCollectionByIDResponses.append(response)
    }
    func getCollectionByID(request: Flow_Access_GetCollectionByIDRequest, context: GRPCAsyncServerCallContext) async throws -> Flow_Access_CollectionResponse {
        getCollectionByIDResponses.removeFirst()
    }

    private var sendTransactionResponses = [Flow_Access_SendTransactionResponse]()
    var hasSendTransactionResponsesRemaining: Bool { !sendTransactionResponses.isEmpty }
    func enqueueSendTransactionResponse(_ response: Flow_Access_SendTransactionResponse) {
        sendTransactionResponses.append(response)
    }
    func sendTransaction(request: Flow_Access_SendTransactionRequest, context: GRPCAsyncServerCallContext) async throws -> Flow_Access_SendTransactionResponse {
        sendTransactionResponses.removeFirst()
    }

    private var getTransactionResponses = [Flow_Access_TransactionResponse]()
    var hasGetTransactionResponsesRemaining: Bool { !getTransactionResponses.isEmpty }
    func enqueueGetTransactionResponse(_ response: Flow_Access_TransactionResponse) {
        getTransactionResponses.append(response)
    }
    func getTransaction(request: Flow_Access_GetTransactionRequest, context: GRPCAsyncServerCallContext) async throws -> Flow_Access_TransactionResponse {
        getTransactionResponses.removeFirst()
    }

    private var getTransactionResultResponses = [Flow_Access_TransactionResultResponse]()
    var hasGetTransactionResultResponsesRemaining: Bool { !getTransactionResultResponses.isEmpty }
    func enqueueGetTransactionResultResponse(_ response: Flow_Access_TransactionResultResponse) {
        getTransactionResultResponses.append(response)
    }
    func getTransactionResult(request: Flow_Access_GetTransactionRequest, context: GRPCAsyncServerCallContext) async throws -> Flow_Access_TransactionResultResponse {
        getTransactionResultResponses.removeFirst()
    }

    private var getTransactionResultByIndexResponses = [Flow_Access_TransactionResultResponse]()
    var hasGetTransactionResultByIndexResponsesRemaining: Bool { !getTransactionResultByIndexResponses.isEmpty }
    func enqueueGetTransactionResultByIndexResponse(_ response: Flow_Access_TransactionResultResponse) {
        getTransactionResultByIndexResponses.append(response)
    }
    func getTransactionResultByIndex(request: Flow_Access_GetTransactionByIndexRequest, context: GRPCAsyncServerCallContext) async throws -> Flow_Access_TransactionResultResponse {
        getTransactionResultByIndexResponses.removeFirst()
    }

    private var getTransactionResultsByBlockIDResponses = [Flow_Access_TransactionResultsResponse]()
    var hasGetTransactionResultsByBlockIDResponsesRemaining: Bool { !getTransactionResultsByBlockIDResponses.isEmpty }
    func enqueueGetTransactionResultsByBlockIDResponse(_ response: Flow_Access_TransactionResultsResponse) {
        getTransactionResultsByBlockIDResponses.append(response)
    }
    func getTransactionResultsByBlockID(request: Flow_Access_GetTransactionsByBlockIDRequest, context: GRPCAsyncServerCallContext) async throws -> Flow_Access_TransactionResultsResponse {
        getTransactionResultsByBlockIDResponses.removeFirst()
    }

    private var getTransactionsByBlockIDResponses = [Flow_Access_TransactionsResponse]()
    var hasGetTransactionsByBlockIDResponsesRemaining: Bool { !getTransactionsByBlockIDResponses.isEmpty }
    func enqueueGetTransactionsByBlockIDResponse(_ response: Flow_Access_TransactionsResponse) {
        getTransactionsByBlockIDResponses.append(response)
    }
    func getTransactionsByBlockID(request: Flow_Access_GetTransactionsByBlockIDRequest, context: GRPCAsyncServerCallContext) async throws -> Flow_Access_TransactionsResponse {
        getTransactionsByBlockIDResponses.removeFirst()
    }

    private var getAccountResponses = [Flow_Access_GetAccountResponse]()
    var hasGetAccountResponsesRemaining: Bool { !getAccountResponses.isEmpty }
    func enqueueGetAccountResponse(_ response: Flow_Access_GetAccountResponse) {
        getAccountResponses.append(response)
    }
    func getAccount(request: Flow_Access_GetAccountRequest, context: GRPCAsyncServerCallContext) async throws -> Flow_Access_GetAccountResponse {
        getAccountResponses.removeFirst()
    }

    private var getAccountAtLatestBlockResponses = [Flow_Access_AccountResponse]()
    var hasGetAccountAtLatestBlockResponsesRemaining: Bool { !getAccountAtLatestBlockResponses.isEmpty }
    func enqueueGetAccountAtLatestBlockResponse(_ response: Flow_Access_AccountResponse) {
        getAccountAtLatestBlockResponses.append(response)
    }
    func getAccountAtLatestBlock(request: Flow_Access_GetAccountAtLatestBlockRequest, context: GRPCAsyncServerCallContext) async throws -> Flow_Access_AccountResponse {
        getAccountAtLatestBlockResponses.removeFirst()
    }

    private var getAccountAtBlockHeightResponses = [Flow_Access_AccountResponse]()
    var hasGetAccountAtBlockHeightResponsesRemaining: Bool { !getAccountAtBlockHeightResponses.isEmpty }
    func enqueueGetAccountAtBlockHeightResponse(_ response: Flow_Access_AccountResponse) {
        getAccountAtBlockHeightResponses.append(response)
    }
    func getAccountAtBlockHeight(request: Flow_Access_GetAccountAtBlockHeightRequest, context: GRPCAsyncServerCallContext) async throws -> Flow_Access_AccountResponse {
        getAccountAtBlockHeightResponses.removeFirst()
    }

    private var executeScriptAtLatestBlockResponses = [Flow_Access_ExecuteScriptResponse]()
    var hasExecuteScriptAtLatestBlockResponsesRemaining: Bool { !executeScriptAtLatestBlockResponses.isEmpty }
    func enqueueExecuteScriptAtLatestBlockResponse(_ response: Flow_Access_ExecuteScriptResponse) {
        executeScriptAtLatestBlockResponses.append(response)
    }
    func executeScriptAtLatestBlock(request: Flow_Access_ExecuteScriptAtLatestBlockRequest, context: GRPCAsyncServerCallContext) async throws -> Flow_Access_ExecuteScriptResponse {
        executeScriptAtLatestBlockResponses.removeFirst()
    }

    private var executeScriptAtBlockIDResponses = [Flow_Access_ExecuteScriptResponse]()
    var hasExecuteScriptAtBlockIDResponsesRemaining: Bool { !executeScriptAtBlockIDResponses.isEmpty }
    func enqueueExecuteScriptAtBlockIDResponse(_ response: Flow_Access_ExecuteScriptResponse) {
        executeScriptAtBlockIDResponses.append(response)
    }
    func executeScriptAtBlockID(request: Flow_Access_ExecuteScriptAtBlockIDRequest, context: GRPCAsyncServerCallContext) async throws -> Flow_Access_ExecuteScriptResponse {
        executeScriptAtBlockIDResponses.removeFirst()
    }

    private var executeScriptAtBlockHeightResponses = [Flow_Access_ExecuteScriptResponse]()
    var hasExecuteScriptAtBlockHeightResponsesRemaining: Bool { !executeScriptAtBlockHeightResponses.isEmpty }
    func enqueueExecuteScriptAtBlockHeightResponse(_ response: Flow_Access_ExecuteScriptResponse) {
        executeScriptAtBlockHeightResponses.append(response)
    }
    func executeScriptAtBlockHeight(request: Flow_Access_ExecuteScriptAtBlockHeightRequest, context: GRPCAsyncServerCallContext) async throws -> Flow_Access_ExecuteScriptResponse {
        executeScriptAtBlockHeightResponses.removeFirst()
    }

    private var getEventsForHeightRangeResponses = [Flow_Access_EventsResponse]()
    var hasGetEventsForHeightRangeResponsesRemaining: Bool { !getEventsForHeightRangeResponses.isEmpty }
    func enqueueGetEventsForHeightRangeResponse(_ response: Flow_Access_EventsResponse) {
        getEventsForHeightRangeResponses.append(response)
    }
    func getEventsForHeightRange(request: Flow_Access_GetEventsForHeightRangeRequest, context: GRPCAsyncServerCallContext) async throws -> Flow_Access_EventsResponse {
        getEventsForHeightRangeResponses.removeFirst()
    }

    private var getEventsForBlockIDsResponses = [Flow_Access_EventsResponse]()
    var hasGetEventsForBlockIDsResponsesRemaining: Bool { !getEventsForBlockIDsResponses.isEmpty }
    func enqueueGetEventsForBlockIDsResponse(_ response: Flow_Access_EventsResponse) {
        getEventsForBlockIDsResponses.append(response)
    }
    func getEventsForBlockIDs(request: Flow_Access_GetEventsForBlockIDsRequest, context: GRPCAsyncServerCallContext) async throws -> Flow_Access_EventsResponse {
        getEventsForBlockIDsResponses.removeFirst()
    }

    private var getNetworkParametersResponses = [Flow_Access_GetNetworkParametersResponse]()
    var hasGetNetworkParametersResponsesRemaining: Bool { !getNetworkParametersResponses.isEmpty }
    func enqueueGetNetworkParametersResponse(_ response: Flow_Access_GetNetworkParametersResponse) {
        getNetworkParametersResponses.append(response)
    }
    func getNetworkParameters(request: Flow_Access_GetNetworkParametersRequest, context: GRPCAsyncServerCallContext) async throws -> Flow_Access_GetNetworkParametersResponse {
        getNetworkParametersResponses.removeFirst()
    }

    private var getLatestProtocolStateSnapshotResponses = [Flow_Access_ProtocolStateSnapshotResponse]()
    var hasGetLatestProtocolStateSnapshotResponsesRemaining: Bool { !getLatestProtocolStateSnapshotResponses.isEmpty }
    func enqueueGetLatestProtocolStateSnapshotResponse(_ response: Flow_Access_ProtocolStateSnapshotResponse) {
        getLatestProtocolStateSnapshotResponses.append(response)
    }
    func getLatestProtocolStateSnapshot(request: Flow_Access_GetLatestProtocolStateSnapshotRequest, context: GRPCAsyncServerCallContext) async throws -> Flow_Access_ProtocolStateSnapshotResponse {
        getLatestProtocolStateSnapshotResponses.removeFirst()
    }

    private var getExecutionResultForBlockIDResponses = [Flow_Access_ExecutionResultForBlockIDResponse]()
    var hasGetExecutionResultForBlockIDResponsesRemaining: Bool { !getExecutionResultForBlockIDResponses.isEmpty }
    func enqueueGetExecutionResultForBlockIDResponse(_ response: Flow_Access_ExecutionResultForBlockIDResponse) {
        getExecutionResultForBlockIDResponses.append(response)
    }
    func getExecutionResultForBlockID(request: Flow_Access_GetExecutionResultForBlockIDRequest, context: GRPCAsyncServerCallContext) async throws -> Flow_Access_ExecutionResultForBlockIDResponse {
        getExecutionResultForBlockIDResponses.removeFirst()
    }

}
