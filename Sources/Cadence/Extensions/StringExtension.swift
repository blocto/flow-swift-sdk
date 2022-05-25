//
//  StringExtension.swift
// 
//  Created by Scott on 2022/5/22.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

extension String {

    var fixedHexString: String {
        if count % 2 == 1 {
            return "0" + self
        } else {
            return self
        }
    }
}
