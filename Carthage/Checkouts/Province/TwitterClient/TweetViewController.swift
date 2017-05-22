//
//  TweetViewController.swift
//  Province
//
//  Created by Jordan Kay on 5/17/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import Mensa
import Province

final class TweetViewController: UIViewController {
    lazy var state: TweetViewControllerState = .init(delegate: self)

    @IBAction func toggleTweetLiked() {
        state.toggleTweetLiked()
    }
    
    @IBAction func showTweetAuthor() {
        let viewController = UserTimelineViewController(user: state.tweet.author)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension TweetViewController: ItemDisplaying {
    typealias Item = Tweet
    typealias View = TweetView
    
    func update(with tweet: Tweet, variant: DisplayVariant, displayed: Bool) {
        state.tweet = tweet
        state.updateTweetLiked(tweet.isLiked)
        view.update(with: tweet, variant: variant)
    }
    
    func itemSizingStrategy(for tweet: Tweet, displayedWith variant: DisplayVariant) -> ItemSizingStrategy {
        return ItemSizingStrategy(widthReference: .containerView, heightReference: .average(TweetView.averageHeight))
    }
}

extension TweetViewController: TweetViewControllerStateDelegate {
    func state(_ state: TweetViewControllerState, didUpdateTweetLiked tweetLiked: ToggleAsyncState) {
        view.updateLikeButton(with: tweetLiked)
    }
}
