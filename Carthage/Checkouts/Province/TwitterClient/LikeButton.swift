//
//  LikeButton.swift
//  Province
//
//  Created by Jordan Kay on 5/16/17.
//  Copyright © 2017 Squareknot. All rights reserved.
//

import Mensa
import Province

final class LikeButton: Button, AsyncToggleable {
    func representation(for state: ToggleAsyncState) -> UIImage {
        switch state {
        case .on:
            return #imageLiteral(resourceName: "LikeIconToggled")
        case .off:
            return #imageLiteral(resourceName: "LikeIcon")
        case .turningOn:
            return #imageLiteral(resourceName: "LikeIconHighlighted")
        case .turningOff:
            return #imageLiteral(resourceName: "LikeIconToggledHighlighted")
        }
    }
}
