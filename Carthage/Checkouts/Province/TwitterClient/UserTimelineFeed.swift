//
//  UserTimeline.swift
//  Province
//
//  Created by Jordan Kay on 5/22/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

struct UserTimelineFeed {
    var items: [TimelineFeedItem] = [LoadingIndicator()]
    
    var data: [Tweet] = [] {
        didSet {
            items = data + [LoadingIndicator()]
        }
    }
    
    fileprivate let user: User
    
    init(user: User) {
        self.user = user
    }
}

extension UserTimelineFeed: TimelineFeed {
    func loadNewerData(count: Int?, since newest: Tweet?) -> TweetsTask {
        return TwitterSession.current.api.success { [user] in
            $0.fetchUserTimeline(for: user, count: count, since: newest, before: nil)
        }
    }
    
    func loadOlderData(count: Int?, before oldest: Tweet?) -> TweetsTask {
        return TwitterSession.current.api.success { [user] in
            $0.fetchUserTimeline(for: user, count: count, since: nil, before: oldest)
        }
    }
}
