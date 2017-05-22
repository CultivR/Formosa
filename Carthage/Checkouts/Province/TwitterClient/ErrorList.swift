//
//  ErrorList.swift
//  Province
//
//  Created by Jordan Kay on 5/18/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import Decodable

struct ErrorList {
    struct Error {
        let code: Int
        let message: String
    }
    
    let errors: [Error]
}

extension ErrorList: Decodable {
    static func decode(_ json: Any) throws -> ErrorList {
        return try ErrorList(
            errors: json => "errors"
        )
    }
}

extension ErrorList.Error: Decodable {
    static func decode(_ json: Any) throws -> ErrorList.Error {
        return try ErrorList.Error(
            code: json => "code",
            message: json => "message"
        )
    }
}

extension ErrorList.Error: Error {}

extension ErrorList.Error: CustomStringConvertible {
    var description: String {
        return "\(message)."
    }
}
