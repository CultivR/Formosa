//
//  TweetView.swift
//  Province
//
//  Created by Jordan Kay on 5/17/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import Emissary
import Mensa
import Province

final class TweetView: UIView {
    @IBOutlet fileprivate var avatarView: UIImageView!
    @IBOutlet fileprivate var authorNameLabel: UILabel!
    @IBOutlet fileprivate var usernameLabel: UILabel!
    @IBOutlet fileprivate var textLabel: UILabel!
    @IBOutlet fileprivate var likeButton: LikeButton!
    
    static var averageHeight: CGFloat {
        return .averageHeight
    }
    
    func updateLikeButton(with state: ToggleAsyncState) {
        likeButton.update(with: state)
    }
    
    // MARK: NSObject
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarView.layer.masksToBounds = true
        avatarView.layer.cornerRadius = .cornerRadius
    }
}

extension TweetView: Displayed {
    func update(with tweet: Tweet, variant: DisplayVariant) {
        avatarView.setImageURL(tweet.author.avatarURL)
        authorNameLabel.text = tweet.author.name
        usernameLabel.text = tweet.author.displayedUsername
        textLabel.text = tweet.text        
    }
}

private extension CGFloat {
    static let cornerRadius: CGFloat = 5
    static let averageHeight: CGFloat = 100
}
