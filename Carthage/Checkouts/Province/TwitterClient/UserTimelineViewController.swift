//
//  UserTimelineViewController.swift
//  Province
//
//  Created by Jordan Kay on 5/22/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import UIKit

final class UserTimelineViewController: FeedViewController<UserTimelineFeed> {
    required init(user: User) {
        let feed = UserTimelineFeed(user: user)
        super.init(feed: feed)
        title = user.name
    }
    
    // MARK: NSCoding
    required init?(coder: NSCoder) {
        fatalError()
    }
}
