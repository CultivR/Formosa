//
//  Tweet.swift
//  Province
//
//  Created by Jordan Kay on 5/17/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import Decodable

struct Tweet {
    let id: Int
    let text: String
    let author: User
    let isLiked: Bool
}

extension Tweet: Decodable {
    static func decode(_ json: Any) throws -> Tweet {
        return try Tweet(
            id: json => "id",
            text: json => "text",
            author: json => "user",
            isLiked: json => "favorited"
        )
    }
}
