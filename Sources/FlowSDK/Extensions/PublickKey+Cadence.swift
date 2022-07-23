//
//  PublicKey.swift
//
//  Created by Scott on 2022/7/24.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation
import Cadence
#if !COCOAPODS
import Crypto
#endif

public extension PublicKey {

    var cadenceValue: Cadence.Value {
        .struct(.init(
            id: "PublicKey",
            fields: [
                .init(
                    name: "publicKey",
                    value: .array(data.map { .uint8($0) })
                ),
                .init(
                    name: "signatureAlgorithm",
                    value: .enum(.init(
                        id: "SignatureAlgorithm",
                        fields: [
                            .init(
                                name: "rawValue",
                                value: .uint8(algorithm.cadenceRawValue))
                        ])
                    )
                ),
            ]
        ))
    }
}
