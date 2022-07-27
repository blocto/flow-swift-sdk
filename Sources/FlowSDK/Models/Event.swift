//
//  Event.swift
// 
//  Created by Scott on 2022/5/20.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation
import Cadence

public struct Event: Equatable {
    /// The qualified event type.
    public let type: String

    /// The ID of the transaction this event was emitted from.
    public let transactionId: Identifier

    /// The index of the transaction this event was emitted from, within its containing block.
    public let transactionIndex: Int

    /// The index of the event within the transaction it was emitted from.
    public let eventIndex: Int

    /// Value contains the event data.
    public let value: Cadence.CompositeEvent

    /// Bytes representing event data.
    public let payload: Data

    public init(
        type: String,
        transactionId: Identifier,
        transactionIndex: Int,
        eventIndex: Int,
        value: Cadence.CompositeEvent,
        payload: Data
    ) {
        self.type = type
        self.transactionId = transactionId
        self.transactionIndex = transactionIndex
        self.eventIndex = eventIndex
        self.value = value
        self.payload = payload
    }

    init(_ value: Flow_Entities_Event) throws {
        self.type = value.type
        self.transactionId = Identifier(data: value.transactionID)
        self.transactionIndex = Int(value.transactionIndex)
        self.eventIndex = Int(value.eventIndex)
        self.payload = value.payload

        if case let .event(event) = try Cadence.Value.decode(data: value.payload) {
            self.value = event
        } else {
            throw Error.notEventValue
        }
    }
}

// MARK: - Error
extension Event {

    public enum Error: Swift.Error {
        case notEventValue
    }
}
