//
//  TwitterAPI+Timeline.swift
//  Province
//
//  Created by Jordan Kay on 5/17/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import SwiftTask

extension TwitterAPI {
    func fetchHomeTimeline(count: Int?, since newest: Tweet? = nil, before oldest: Tweet? = nil) -> TweetsTask {
        let parameters = timelineParameters(count: count, since: newest, before: oldest)
        return task(for: .timeline(.home), parameters: parameters)
    }
    
    func fetchUserTimeline(for user: User, count: Int?, since newest: Tweet? = nil, before oldest: Tweet? = nil) -> TweetsTask {
        let parameters = userTimelineParameters(user: user, count: count, since: newest, before: oldest)
        return task(for: .timeline(.user), parameters: parameters)
    }
}

private func timelineParameters(count: Int?, since newest: Tweet?, before oldest: Tweet?) -> [String: String] {
    var parameters: [String: String] = [:]
    if let count = count {
        parameters["count"] = "\(count)"
    }
    if let sinceID = newest?.id {
        parameters["since_id"] = "\(sinceID + 1)"
    } else if let maxID = oldest?.id {
        parameters["max_id"] = "\(maxID - 1)"
    }
    return parameters
}

private func userTimelineParameters(user: User, count: Int?, since newest: Tweet?, before oldest: Tweet?) -> [String: String] {
    var parameters = timelineParameters(count: count, since: newest, before: oldest)
    parameters["screen_name"] = user.username
    return parameters
}
