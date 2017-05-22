//
//  TimelineFeed.swift
//  Province
//
//  Created by Jordan Kay on 5/17/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

struct HomeTimelineFeed {
    var items: [TimelineFeedItem] = [LoadingIndicator()]
    
    var data: [Tweet] = [] {
        didSet {
            items = data + [LoadingIndicator()]
        }
    }
}

extension HomeTimelineFeed: TimelineFeed {
    func loadNewerData(count: Int?, since newest: Tweet?) -> TweetsTask {
        return TwitterSession.current.api.success {
            $0.fetchHomeTimeline(count: count, since: newest, before: nil)
        }
    }

    func loadOlderData(count: Int?, before oldest: Tweet?) -> TweetsTask {
        return TwitterSession.current.api.success {
            $0.fetchHomeTimeline(count: count, since: nil, before: oldest)
        }
    }
}
