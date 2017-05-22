//
//  ViewController.swift
//  TwitterClient
//
//  Created by Jordan Kay on 5/17/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import UIKit

final class HomeTimelineViewController: UIViewController {
    // MARK: NSObject
    override func awakeAfter(using coder: NSCoder) -> Any? {
        let feed = HomeTimelineFeed()
        return FeedViewController(feed: feed, coder: coder)
    }
}
