//
//  User.swift
//  Province
//
//  Created by Jordan Kay on 5/17/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import Decodable

struct User {
    let name: String
    let username: String
    let avatarURL: URL
    
    var displayedUsername: String {
        return "@\(username)"
    }
}

extension User: Decodable {
    static func decode(_ json: Any) throws -> User {
        return try User(
            name: json => "name",
            username: json => "screen_name",
            avatarURL: json => "profile_image_url"
        )
    }
}
