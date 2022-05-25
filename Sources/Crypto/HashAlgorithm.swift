//
//  HashAlgorithm.swift
// 
//  Created by Scott on 2022/5/22.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

public enum HashAlgorithm: UInt32, RawRepresentable {
    /// SHA2_256 is SHA-2 with a 256-bit digest (also referred to as SHA256).
    case sha2_256 = 1

    /// SHA3_256 is SHA-3 with a 256-bit digest.
    case sha3_256 = 3
}

extension HashAlgorithm {

    func getDigest(message: Data) -> SHA256Digest {
        let digest: SHA256Digest
        switch self {
        case .sha2_256:
            digest = SHA256Digest(data: message.sha256())!
        case .sha3_256:
            digest = SHA256Digest(data: message.sha3(.sha256))!
        }
        return digest
    }
}
