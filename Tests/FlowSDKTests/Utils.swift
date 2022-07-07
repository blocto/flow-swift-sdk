//
//  Utils.swift
// 
//  Created by Scott on 2022/6/30.
//  Copyright © 2022 portto. All rights reserved.
//

import Foundation

enum Utils {

    static func getHexData(name: String) throws -> Data {
        let data = try getTestData(name: name)
        let hexText = (String(data: data, encoding: .utf8) ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return Data(hex: hexText)
    }

    static func getTestData(name: String) throws -> Data {
        try getFile("TestData/\(name)")
    }

    private static func getFile(_ name: String, ext: String = "") throws -> Data {
        guard let url = Bundle.module.url(forResource: name, withExtension: ext) else {
            throw Error.fileNotFound
        }
        return try Data(contentsOf: url)
    }

    enum Error: Swift.Error {
        case fileNotFound
    }
}
