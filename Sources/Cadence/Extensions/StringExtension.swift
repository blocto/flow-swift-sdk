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

    var quoteString: String {
        var result = ""
        result += "\""

        unicodeScalars.forEach { char in
            switch char {
            case "\0":
                result += #"\0"#
            case "\n":
                result += #"\n"#
            case "\r":
                result += #"\r"#
            case "\t":
                result += #"\t"#
            case "\\":
                result += #"\\"#
            case "\"":
                result += #"\""#
            default:
                if 0x20 <= char.value && char.value <= 0x7E {
                    // ASCII printable from space through DEL-1.
                    result += String(char)
                } else {
                    let finalChar: Unicode.Scalar
                    if char.value > 1114111 {
                        finalChar = Unicode.Scalar(65533 as UInt32) ?? char
                    } else {
                        finalChar = char
                    }
                    result += finalChar.description
                }
            }
        }
        result += "\""
        return result
    }

}
