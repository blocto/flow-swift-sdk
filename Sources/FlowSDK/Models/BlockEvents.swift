//
//  BlockEvents.swift
// 
//  Created by Scott on 2022/6/1.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation
#if !COCOAPODS
import Protobuf
#endif

/// The events that occurred in a specific block.
public struct BlockEvents: Equatable {

    public let blockId: Identifier

    public let height: UInt64

    public let blockDate: Date

    public let events: [Event]

    public init(
        blockId: Identifier,
        height: UInt64,
        blockDate: Date,
        events: [Event]
    ) {
        self.blockId = blockId
        self.height = height
        self.blockDate = blockDate
        self.events = events
    }

    init(_ value: Flow_Access_EventsResponse.Result) throws {
        self.blockId = Identifier(data: value.blockID)
        self.height = value.blockHeight
        self.blockDate = value.blockTimestamp.date
        self.events = try value.events.map { try Event($0) }
    }
}
