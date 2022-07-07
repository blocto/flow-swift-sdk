//
//  TransactionResult.swift
// 
//  Created by Scott on 2022/5/21.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation
#if !COCOAPODS
import Protobuf
#endif

public struct TransactionResult: Equatable {
    public let status: TransactionStatus?
    public let errorMessage: String?
    public let events: [Event]
    public let blockId: Identifier

    public init(
        status: TransactionStatus?,
        errorMessage: String?,
        events: [Event],
        blockId: Identifier
    ) {
        self.status = status
        self.errorMessage = errorMessage
        self.events = events
        self.blockId = blockId
    }

    init(_ value: Flow_Access_TransactionResultResponse) throws {
        let errorMessage: String?
        if value.statusCode != 0 {
            errorMessage = value.errorMessage == "" ? "transaction execution failed" : value.errorMessage
        } else {
            errorMessage = nil
        }
        self.status = value.status
        self.errorMessage = errorMessage
        self.events = try value.events.map { try Event($0) }
        self.blockId = Identifier(data: value.blockID)
    }
}

// MARK: - TransactionStatus

public typealias TransactionStatus = Flow_Entities_TransactionStatus
