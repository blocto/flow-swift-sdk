//
//  Network.swift
//
//  Created by Scott on 2022/6/21.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

public enum Network: String {
    case mainnet
    case testnet
    case canarynet
    case sandboxnet
    case emulator

    var endpoint: Endpoint {
        switch self {
        case .mainnet:
            return Endpoint(host: "access.mainnet.nodes.onflow.org", port: 9000)
        case .testnet:
            return Endpoint(host: "access.devnet.nodes.onflow.org", port: 9000)
        case .canarynet:
            return Endpoint(host: "access.canary.nodes.onflow.org", port: 9000)
        case .sandboxnet:
            return Endpoint(host: "access.sandboxnet.nodes.onflow.org", port: 9000)
        case .emulator:
            return Endpoint(host: "127.0.0.1", port: 3569)
        }
    }
}

// MARK: - Endpoint

extension Network {

    public struct Endpoint {

        public let host: String
        public let port: Int

        public init(host: String, port: Int) {
            self.host = host
            self.port = port
        }
    }
}
