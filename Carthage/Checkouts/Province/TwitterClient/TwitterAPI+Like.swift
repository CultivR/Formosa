//
//  TwitterAPI+Like.swift
//  Province
//
//  Created by Jordan Kay on 5/19/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import SwiftTask

extension TwitterAPI {
    func like(_ tweet: Tweet) -> BasicTask {
        return setLiked(true, for: tweet)
    }
    
    func dislike(_ tweet: Tweet) -> BasicTask {
        return setLiked(false, for: tweet)
    }
}

private extension TwitterAPI {
    func setLiked(_ liked: Bool, for tweet: Tweet) -> BasicTask {
        let parameters = ["id": "\(tweet.id)"]
        return task(for: .like(liked), parameters: parameters)
    }
}
