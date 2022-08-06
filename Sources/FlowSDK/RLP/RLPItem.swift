//
//  RLPItem.swift
//
//  Created by Scott on 2022/8/6.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

public enum RLPItem: Equatable {
    case empty
    case data(Data)
    indirect case list([RLPItem])

    public func getListItems() throws -> [RLPItem] {
        switch self {
        case .empty, .data:
            throw RLPDecodingError.notListType
        case let .list(items):
            return items
        }
    }
}
