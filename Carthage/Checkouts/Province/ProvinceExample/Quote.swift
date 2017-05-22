//
//  Quote.swift
//  Province
//
//  Created by Jordan Kay on 5/13/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import Decodable

struct Quote {
    let character: String
    let line: String
}

extension Quote: Decodable {
    static func decode(_ json: Any) throws -> Quote {
        return try Quote(
            character: json => "character",
            line: json => "line"
        )
    }
}
