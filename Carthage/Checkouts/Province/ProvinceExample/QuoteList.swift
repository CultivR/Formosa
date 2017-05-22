//
//  QuoteList.swift
//  Province
//
//  Created by Jordan Kay on 5/13/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import Decodable

struct QuoteList {
    let quotes: [Quote]
}

extension QuoteList: Decodable {
    static func decode(_ json: Any) throws -> QuoteList {
        return try QuoteList(
            quotes: json => "quotes"
        )
    }
}
