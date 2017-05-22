//
//  TimelineFeed.swift
//  Province
//
//  Created by Jordan Kay on 5/17/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import Mensa
import Province

protocol TimelineFeed: Feed, DataSource {
    var items: [TimelineFeedItem] { get }
}

extension TimelineFeed {
    var sections: [Section<TimelineFeedItem>] {
        return [Section(items)]
    }
}

protocol TimelineFeedItem {}

extension Tweet: TimelineFeedItem {}
extension LoadingIndicator: TimelineFeedItem {}
