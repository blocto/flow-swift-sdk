//
//  DomainTag.swift
// 
//  Created by Scott on 2022/5/22.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

private let domainTagLength = 32

/// A domain tag is encoded as UTF-8 bytes, right padded to a total length of 32 bytes.
public enum DomainTag: String {

    /// The prefix of all signed transaction payloads.
    case transaction = "FLOW-V0.0-transaction"

    /// The prefix of all signed user space payloads.
    case user = "FLOW-V0.0-user"

    public var rightPaddedData: Data {
        var data = rawValue.data(using: .utf8) ?? Data()
        while data.count < domainTagLength {
            data.append(0)
        }
        return data
    }
}
