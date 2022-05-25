//
//  Signer.swift
// 
//  Created by Scott on 2022/6/5.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

public protocol Signer {

    /// PublicKey returns the verification public key corresponding to the signer
    var publicKey: PublicKey { get }

    /// Signs the given message with this signer.
    /// - Returns: signature
    func sign(message: Data) throws -> Data
}
