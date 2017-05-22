//
//  HomeTimelineViewControllerState.swift
//  Province
//
//  Created by Jordan Kay on 5/17/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import SwiftTask

public class FeedViewControllerState<FeedType: Feed>: StateHolder {
    private var feed: FeedType!
    public weak var delegate: FeedViewControllerStateDelegate?
    
    private var feedLoadingState: FeedLoadingState<FeedType> = .notYetLoaded {
        didSet {
            delegate?.state(self, didUpdate: feedLoadingState)
        }
    }
    
    public convenience init(feed: FeedType, delegate: FeedViewControllerStateDelegate) {
        self.init(delegate: delegate)
        self.feed = feed
    }
    
    public required init(delegate: FeedViewControllerStateDelegate) {
        self.delegate = delegate
    }
    
    public func loadInitialData(count: Int?) {
        let task = feed.loadNewerData(count: count, since: nil)
        try! feedLoadingState.transition(with: .load(nil), task: task) { [weak self] in
            self?.feedLoadingState = $0
        }
    }
    
    public func loadNewerData(count: Int?, since newest: FeedType.Data) {
        let task = feed.loadNewerData(count: count, since: newest)
        try! feedLoadingState.transition(with: .load(.top), task: task) { [weak self] in
            self?.feedLoadingState = $0
        }
    }
    
    public func loadOlderData(count: Int?, before oldest: FeedType.Data) {
        let task = feed.loadOlderData(count: count, before: oldest)
        try! feedLoadingState.transition(with: .load(.bottom), task: task) { [weak self] in
            self?.feedLoadingState = $0
        }
    }
}

public protocol FeedViewControllerStateDelegate: class {
    func state<T: Feed>(_ state: FeedViewControllerState<T>, didUpdate feedLoadingState: FeedLoadingState<T>)
}
