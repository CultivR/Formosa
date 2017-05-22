//
//  TweetViewControllerState.swift
//  Province
//
//  Created by Jordan Kay on 5/19/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import Province
import SwiftTask

final class TweetViewControllerState: StateHolder {
    var tweet: Tweet!
    
    weak var delegate: TweetViewControllerStateDelegate?
    
    private(set) var tweetLiked: ToggleAsyncState = .off {
        didSet {
            delegate?.state(self, didUpdateTweetLiked: tweetLiked)
        }
    }
    
    private var toggleTweetLikedTask: BasicTask?
    
    init(delegate: TweetViewControllerStateDelegate) {
        self.delegate = delegate
    }
    
    func toggleTweetLiked() {
        toggleTweetLikedTask?.cancel()
        toggleTweetLikedTask = TwitterSession.current.api.success { [tweet, tweetLiked] api -> BasicTask in
            switch tweetLiked {
            case .on:
                return api.dislike(tweet!)
            case .off:
                return api.like(tweet!)
            case .turningOn, .turningOff:
                return .noop
            }
        }
        
        try! tweetLiked.transition(with: .toggle(optimistic: true), task: toggleTweetLikedTask!) { [weak self] in
            self?.tweetLiked = $0
        }
    }
    
    func updateTweetLiked(_ liked: Bool) {
        try! tweetLiked.transition(with: liked ? .forceOn : .forceOff) { [weak self] in
            self?.tweetLiked = $0
        }
    }
}

protocol TweetViewControllerStateDelegate: class {
    func state(_ state: TweetViewControllerState, didUpdateTweetLiked tweetLiked: ToggleAsyncState)
}
