//
//  PublicKey.swift
//
//  Created by Scott on 2022/7/24.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation
import Cadence

public extension PublicKey {

    var cadenceArugment: Cadence.Argument {
        .struct(
            id: "PublicKey",
            fields: [
                .init(
                    name: "publicKey",
                    value: .array(data.map { .uint8($0) }) 
                ),
                .init(
                    name: "signatureAlgorithm",
                    value: .enum(
                        id: "SignatureAlgorithm",
                        fields: [
                            .init(
                                name: "rawValue",
                                value: .uint8(algorithm.cadenceRawValue))
                        ]
                    )
                ),
            ]
        )
    }
}
