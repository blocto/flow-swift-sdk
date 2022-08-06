//
//  File.swift
// 
//  Created by Scott on 2022/5/22.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

public protocol RLPEncodableList {
    var rlpList: RLPEncoableArray { get }
}
